<?php

header('Content-Type: application/json; charset=utf-8');

$requestId = bin2hex(random_bytes(8));
header('X-Request-ID: ' . $requestId);
$logDiagnostic = static function (string $event, array $context = []) use ($requestId): void {
    $entry = ['request_id' => $requestId, 'event' => $event] + $context;
    error_log('Photo upload diagnostic: ' . json_encode($entry, JSON_UNESCAPED_SLASHES | JSON_INVALID_UTF8_SUBSTITUTE));
};
$respond = static function (int $status, array $payload): void {
    http_response_code($status);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
};

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    header('Allow: POST');
    $respond(405, ['success' => false, 'error' => 'Méthode non autorisée.', 'code' => 'METHOD_NOT_ALLOWED']);
    exit;
}

try {
    require_once __DIR__ . '/../vendor/autoload.php';
} catch (Throwable $e) {
    $logDiagnostic('dependency_load_failed', ['status' => 503, 'exception_type' => get_class($e)]);
    $respond(503, ['success' => false, 'error' => 'Service de stockage photo indisponible.', 'code' => 'UPLOAD_DEPENDENCY_UNAVAILABLE']);
    exit;
}

$readEnvironment = static function (string $name): string {
    foreach ([getenv($name), $_ENV[$name] ?? null, $_SERVER[$name] ?? null] as $value) {
        if ($value !== false && $value !== null && trim((string) $value) !== '') {
            return trim((string) $value);
        }
    }
    return '';
};

$cloudName = $readEnvironment('CLOUDINARY_CLOUD_NAME');
$apiKey = $readEnvironment('CLOUDINARY_API_KEY');
$apiSecret = $readEnvironment('CLOUDINARY_API_SECRET');
$missing = [];
foreach ([
    'CLOUDINARY_CLOUD_NAME' => $cloudName,
    'CLOUDINARY_API_KEY' => $apiKey,
    'CLOUDINARY_API_SECRET' => $apiSecret
] as $name => $value) {
    if ($value === '') {
        $missing[] = $name;
    }
}
if ($missing !== []) {
    $logDiagnostic('configuration_missing', ['status' => 503, 'missing_variables' => $missing]);
    $respond(503, ['success' => false, 'error' => 'Stockage photo non configuré sur le serveur.', 'code' => 'UPLOAD_CONFIGURATION_MISSING']);
    exit;
}

if (!isset($_FILES['photo']) || !is_array($_FILES['photo'])) {
    $respond(400, ['success' => false, 'error' => 'Choisissez une photo avant de continuer.', 'code' => 'PHOTO_REQUIRED']);
    exit;
}
$file = $_FILES['photo'];
if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
    $uploadErrors = [
        UPLOAD_ERR_INI_SIZE => 'La photo dépasse la limite autorisée par le serveur.',
        UPLOAD_ERR_FORM_SIZE => 'La photo dépasse la taille maximale autorisée.',
        UPLOAD_ERR_PARTIAL => 'Le téléversement de la photo est incomplet.',
        UPLOAD_ERR_NO_FILE => 'Choisissez une photo avant de continuer.',
        UPLOAD_ERR_NO_TMP_DIR => 'Le serveur ne peut pas recevoir de fichier temporaire.',
        UPLOAD_ERR_CANT_WRITE => 'Le serveur ne peut pas enregistrer temporairement la photo.',
        UPLOAD_ERR_EXTENSION => 'Le serveur a interrompu le téléversement de la photo.'
    ];
    $code = (int) $file['error'];
    $logDiagnostic('php_upload_failed', ['upload_error_code' => $code]);
    $respond($code === UPLOAD_ERR_INI_SIZE || $code === UPLOAD_ERR_FORM_SIZE ? 413 : 400, [
        'success' => false,
        'error' => $uploadErrors[$code] ?? 'Le fichier photo n’a pas pu être reçu.',
        'code' => 'PHOTO_UPLOAD_FAILED'
    ]);
    exit;
}

$maxBytes = 5 * 1024 * 1024;
if (!isset($file['size']) || (int) $file['size'] <= 0 || (int) $file['size'] > $maxBytes) {
    $respond(413, ['success' => false, 'error' => 'La photo doit faire moins de 5 Mo.', 'code' => 'PHOTO_TOO_LARGE']);
    exit;
}
if (!isset($file['tmp_name']) || !is_uploaded_file($file['tmp_name'])) {
    $respond(400, ['success' => false, 'error' => 'Le fichier reçu n’est pas un téléversement valide.', 'code' => 'INVALID_UPLOAD']);
    exit;
}

try {
    $mime = (new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);
} catch (Throwable $e) {
    $logDiagnostic('mime_inspection_failed', ['status' => 500, 'exception_type' => get_class($e)]);
    $respond(500, ['success' => false, 'error' => 'Le serveur ne peut pas vérifier le format de la photo.', 'code' => 'PHOTO_VALIDATION_FAILED']);
    exit;
}
if (!in_array($mime, ['image/jpeg', 'image/png', 'image/webp'], true)) {
    $respond(415, ['success' => false, 'error' => 'Formats acceptés : JPG, PNG et WEBP.', 'code' => 'UNSUPPORTED_PHOTO_TYPE']);
    exit;
}

try {
    $logDiagnostic('cloudinary_upload_started', ['file_size' => (int) $file['size'], 'mime_type' => $mime]);
    \Cloudinary\Configuration\Configuration::instance("cloudinary://{$apiKey}:{$apiSecret}@{$cloudName}");
    $result = (new \Cloudinary\Api\Upload\UploadApi())->upload($file['tmp_name'], [
        'folder' => 'chriwbie',
        'resource_type' => 'image'
    ]);
    $url = $result['secure_url'] ?? null;
    if (!is_string($url) || filter_var($url, FILTER_VALIDATE_URL) === false || strtolower((string) parse_url($url, PHP_URL_SCHEME)) !== 'https') {
        $logDiagnostic('cloudinary_url_invalid', ['status' => 502, 'secure_url_valid' => false]);
        $respond(502, ['success' => false, 'error' => 'Le stockage photo n’a pas confirmé l’image.', 'code' => 'UPLOAD_URL_MISSING']);
        exit;
    }
    $logDiagnostic('cloudinary_upload_succeeded', ['status' => 201, 'secure_url_valid' => true, 'url_host' => strtolower((string) parse_url($url, PHP_URL_HOST)), 'file_size' => (int) $file['size']]);
    $respond(201, ['success' => true, 'url' => $url]);
} catch (Throwable $e) {
    $errorCode = $e->getCode();
    $safeCode = is_scalar($errorCode) && preg_match('/^[A-Za-z0-9_-]{1,20}$/', (string) $errorCode)
        ? (string) $errorCode : 'unknown';
    $safeMessage = trim((string) $e->getMessage());
    foreach ([$apiKey, $apiSecret, $cloudName] as $credential) {
        if ($credential !== '') {
            $safeMessage = str_replace($credential, '[redacted]', $safeMessage);
        }
    }
    $safeMessage = substr((string) preg_replace('/[\r\n\t]+/', ' ', $safeMessage), 0, 400);
    $logDiagnostic('cloudinary_upload_failed', [
        'status' => 502,
        'exception_type' => get_class($e),
        'error_code' => $safeCode,
        'provider_message' => $safeMessage
    ]);
    $respond(502, [
        'success' => false,
        'error' => 'Cloudinary a refusé le téléversement : ' . ($safeMessage !== '' ? $safeMessage : 'cause non détaillée') . ' (référence ' . $requestId . ').',
        'code' => 'CLOUDINARY_UPLOAD_FAILED'
    ]);
}
