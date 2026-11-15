<?php

if (session_status() === PHP_SESSION_NONE) {
    $isHttps = (
        (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https')
    );

    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'secure' => $isHttps,
        'httponly' => true,
        'samesite' => 'Lax'
    ]);

    session_start();
}

function verifierAdmin() {
    if (empty($_SESSION['admin_id'])) {
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'message' => 'Accès non autorisé'
        ]);
        exit;
    }
}