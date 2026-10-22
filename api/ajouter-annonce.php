<?php

header('Content-Type: application/json; charset=utf-8');

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
    error_log(sprintf('Announcement database setup failed (type: %s, code: %s).', get_class($e), (string) $e->getCode()));
    $respond(503, [
        'success' => false,
        'error' => $missingConfiguration
            ? 'Configuration de la base de données absente.'
            : 'Connexion à la base de données indisponible.'
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

try {
    $sql = "INSERT INTO annonces
            (titre, description, prix, ville, categorie, photo)
            VALUES (:titre, :description, :prix, :ville, :categorie, :photo)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        'titre' => $titre,
        'description' => $description,
        'prix' => $prix !== null && $prix !== '' ? $prix : null,
        'ville' => $ville,
        'categorie' => $categorie,
        'photo' => $photo
    ]);
    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('Insertion annonce sans ligne affectée.');
    }

    $respond(201, ['success' => true, 'id' => $pdo->lastInsertId()]);
} catch (Throwable $e) {
    if ($e instanceof PDOException) {
        $sqlState = (string) $e->getCode();
        $driverCode = isset($e->errorInfo[1]) ? (string) $e->errorInfo[1] : 'unknown';
        error_log(sprintf(
            'Announcement insert failed (SQLSTATE: %s, driver code: %s).',
            preg_match('/^[A-Z0-9]{5}$/', $sqlState) ? $sqlState : 'unknown',
            ctype_digit($driverCode) ? $driverCode : 'unknown'
        ));
    } else {
        error_log(sprintf('Announcement insert failed (type: %s, code: %s).', get_class($e), (string) $e->getCode()));
    }
    $respond(500, ['success' => false, 'error' => 'Erreur lors de l’enregistrement de l’annonce.']);
}
