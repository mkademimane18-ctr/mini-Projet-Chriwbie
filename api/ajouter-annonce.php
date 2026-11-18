<?php

header('Content-Type: application/json; charset=utf-8');

$requestId = bin2hex(random_bytes(8));
header('X-Request-ID: ' . $requestId);
$logDiagnostic = static function (string $event, array $context = []) use ($requestId): void {
    $entry = ['request_id' => $requestId, 'event' => $event] + $context;
    error_log('Announcement diagnostic: ' . json_encode($entry, JSON_UNESCAPED_SLASHES | JSON_INVALID_UTF8_SUBSTITUTE));
};
$respond = static function (int $status, array $payload): void {
    http_response_code($status);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
};

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Allow: POST');
    $respond(405, ['success' => false, 'error' => 'Méthode non autorisée.']);
    exit;
}

try {
    require_once __DIR__ . '/../config/db.php';
} catch (Throwable $e) {
    $missingConfiguration = $e->getCode() === 1001;
    $logDiagnostic('database_setup_failed', ['exception_type' => get_class($e), 'exception_code' => (string) $e->getCode()]);
    $respond(503, [
        'success' => false,
        'error' => $missingConfiguration
            ? 'Configuration de la base de données absente.'
            : 'Connexion à la base de données indisponible.',
        'code' => $missingConfiguration ? 'DATABASE_CONFIGURATION_MISSING' : 'DATABASE_UNAVAILABLE',
        'request_id' => $requestId
    ]);
    exit;
}

$rawBody = file_get_contents('php://input');
$data = json_decode($rawBody, true);
if (!is_array($data)) {
    $data = $_POST;
}

$titre = trim((string) ($data['titre'] ?? ''));
$description = trim((string) ($data['description'] ?? ''));
$prix = $data['prix'] ?? null;
$ville = trim((string) ($data['ville'] ?? ''));
$categorie = trim((string) ($data['categorie'] ?? ''));
$photo = trim((string) ($data['photo'] ?? ''));

if ($titre === '') {
    $respond(400, ['success' => false, 'error' => 'Le titre est obligatoire.']);
    exit;
}
if ($prix !== null && $prix !== '' && (!is_numeric($prix) || (float) $prix < 0)) {
    $respond(400, ['success' => false, 'error' => 'Le prix doit être un nombre positif ou nul.']);
    exit;
}

$demoEmail = trim((string) ($_ENV['DEMO_ANNOUNCER_EMAIL'] ?? $_SERVER['DEMO_ANNOUNCER_EMAIL'] ?? getenv('DEMO_ANNOUNCER_EMAIL') ?: ''));
$demoUsername = trim((string) ($_ENV['DEMO_ANNOUNCER_USERNAME'] ?? $_SERVER['DEMO_ANNOUNCER_USERNAME'] ?? getenv('DEMO_ANNOUNCER_USERNAME') ?: ''));
if ($demoEmail === '' || $demoUsername === '') {
    $logDiagnostic('demo_announcer_configuration_missing');
    $respond(503, [
        'success' => false,
        'error' => 'La configuration de l’annonceur de démonstration est absente.',
        'code' => 'DEMO_ANNOUNCER_CONFIGURATION_MISSING',
        'request_id' => $requestId
    ]);
    exit;
}

try {
    $announcerLookup = $pdo->prepare(
        'SELECT id FROM annonceurs WHERE email = :email AND nom_utilisateur = :username LIMIT 2'
    );
    $announcerLookup->execute(['email' => $demoEmail, 'username' => $demoUsername]);
    $announcerRows = $announcerLookup->fetchAll(PDO::FETCH_COLUMN);
    if (count($announcerRows) !== 1 || !ctype_digit((string) $announcerRows[0]) || (int) $announcerRows[0] < 1) {
        $logDiagnostic('demo_announcer_not_found_or_ambiguous', ['match_count' => count($announcerRows)]);
        $respond(503, [
            'success' => false,
            'error' => 'L’annonceur de démonstration est absent ou ambigu. Vérifiez son enregistrement dans la base.',
            'code' => count($announcerRows) === 0 ? 'DEMO_ANNOUNCER_NOT_FOUND' : 'DEMO_ANNOUNCER_AMBIGUOUS',
            'request_id' => $requestId
        ]);
        exit;
    }
    $announcerId = (int) $announcerRows[0];

    $sql = "INSERT INTO annonces
            (titre, description, prix, ville, categorie, photo, annonceur_id)
            VALUES (:titre, :description, :prix, :ville, :categorie, :photo, :annonceur_id)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        'titre' => $titre,
        'description' => $description,
        'prix' => $prix !== null && $prix !== '' ? $prix : null,
        'ville' => $ville,
        'categorie' => $categorie,
        'photo' => $photo,
        'annonceur_id' => $announcerId
    ]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('Insertion annonce sans ligne affectée.');
    }

    $respond(201, ['success' => true, 'id' => $pdo->lastInsertId()]);
} catch (Throwable $e) {
    $annonceurRequired = false;
    if ($e instanceof PDOException) {
        $sqlState = (string) $e->getCode();
        $driverCode = isset($e->errorInfo[1]) ? (string) $e->errorInfo[1] : 'unknown';
        $detail = isset($e->errorInfo[2]) ? (string) $e->errorInfo[2] : $e->getMessage();

        // Keep useful MySQL/trigger diagnostics while removing submitted data and credentials.
        $sensitiveValues = [
            $host ?? null, $user ?? null, $password ?? null, $dbname ?? null,
            $titre ?? null, $description ?? null, $prix ?? null, $ville ?? null, $categorie ?? null, $photo ?? null
        ];
        foreach ($sensitiveValues as $sensitiveValue) {
            if (is_string($sensitiveValue) && $sensitiveValue !== '') {
                $detail = str_replace($sensitiveValue, '[redacted]', $detail);
            }
        }
        $detail = preg_replace('/[\r\n\t]+/', ' ', $detail);
        $detail = substr((string) $detail, 0, 500);
        $annonceurRequired = $sqlState === '45000' && stripos($detail, 'annonceur inexistant') !== false;

        $logDiagnostic('announcement_insert_failed', [
            'sqlstate' => preg_match('/^[A-Z0-9]{5}$/', $sqlState) ? $sqlState : 'unknown',
            'driver_code' => ctype_digit($driverCode) ? $driverCode : 'unknown',
            'detail' => $detail !== '' ? $detail : 'unavailable'
        ]);
    } else {
        $logDiagnostic('announcement_insert_failed', ['exception_type' => get_class($e), 'exception_code' => (string) $e->getCode()]);
    }
    if ($annonceurRequired) {
        $respond(422, [
            'success' => false,
            'error' => 'Un annonceur valide doit être associé à cette annonce.',
            'code' => 'ANNONCEUR_REQUIRED',
            'request_id' => $requestId
        ]);
    } else {
        $respond(500, [
            'success' => false,
            'error' => 'Erreur lors de l’enregistrement de l’annonce. Référence de diagnostic : ' . $requestId . '.',
            'code' => 'ANNOUNCEMENT_INSERT_FAILED',
            'request_id' => $requestId
        ]);
    }
}
