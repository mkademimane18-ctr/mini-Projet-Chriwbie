
<?php

if (session_status() === PHP_SESSION_NONE) {

    $isHttps =
        (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        || (
            isset($_SERVER['HTTP_X_FORWARDED_PROTO'])
            && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https'
        );

    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'httponly' => true,
        'secure' => $isHttps,
        'samesite' => 'Lax'
    ]);

    session_start();
}

function verifierAdmin(): void {
    if (!isset($_SESSION['admin_id'])) {
        http_response_code(401);

        echo json_encode([
            'success' => false,
            'message' => 'Accès non autorisé'
        ]);

        exit;
    }
}
