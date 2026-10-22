<?php

header('Content-Type: application/json; charset=utf-8');

set_error_handler(static function (int $severity, string $message, string $file, int $line): bool {
    if (!(error_reporting() & $severity)) {
        return false;
    }

    throw new ErrorException($message, 0, $severity, $file, $line);
});

try {
    require_once __DIR__ . '/../config/db.php';
    http_response_code(200);
    echo json_encode([
        'success' => true,
        'message' => 'Database connection is available.'
    ], JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
} catch (Throwable $e) {
    $configurationMissing = $e->getCode() === 1001;
    $connectionFailed = $e->getCode() === 1002;

    error_log(sprintf(
        'Database health check failed (type: %s, code: %s).',
        get_class($e),
        (string) $e->getCode()
    ));

    http_response_code(503);
    echo json_encode([
        'success' => false,
        'error' => $configurationMissing
            ? 'Configuration de base de donnees absente. Configurez DB_HOST, DB_USER et DB_PASSWORD dans Vercel.'
            : ($connectionFailed
                ? 'Connexion MySQL indisponible. Verifiez la configuration reseau et les identifiants dans Vercel.'
                : 'Service de base de donnees indisponible.'),
        'code' => $configurationMissing
            ? 'DATABASE_CONFIGURATION_MISSING'
            : ($connectionFailed ? 'DATABASE_CONNECTION_FAILED' : 'DATABASE_UNAVAILABLE')
    ], JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
} finally {
    restore_error_handler();
}
