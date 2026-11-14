
<?php
require_once __DIR__ . '/auth.php';

header('Content-Type: application/json; charset=utf-8');

verifierAdmin();

echo json_encode([
    'success' => true,
    'admin' => [
        'id' => $_SESSION['admin_id'],
        'nom' => $_SESSION['admin_nom'],
        'prenom' => $_SESSION['admin_prenom'],
        'email' => $_SESSION['admin_email']
    ]
]);
