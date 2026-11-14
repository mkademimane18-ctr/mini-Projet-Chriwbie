
<?php
if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params([
        'httponly' => true,
        'secure' => !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off',
        'samesite' => 'Lax'
    ]);

    session_start();
}

function verifierAdmin() {
    if (!isset($_SESSION['admin_id'])) {
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'message' => 'Accès non autorisé'
        ]);
        exit;
    }
}

