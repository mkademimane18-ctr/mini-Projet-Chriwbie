<?php

require_once __DIR__ . '/auth.php';

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit(json_encode([
        'success' => false,
        'message' => 'Méthode non autorisée'
    ]));
}

try {
    require_once __DIR__ . '/../../config/db.php';

    $data = json_decode(file_get_contents('php://input'), true) ?? [];

    $identifiant = trim($data['identifiant'] ?? '');
    $password = $data['mot_de_passe'] ?? '';

    if ($identifiant === '' || $password === '') {
        http_response_code(400);
        exit(json_encode([
            'success' => false,
            'message' => 'Veuillez remplir tous les champs.'
        ]));
    }

    $stmt = $pdo->prepare("
        SELECT id, nom, prenom, email, nom_utilisateur, mot_de_passe
        FROM admins
        WHERE email = ? OR nom_utilisateur = ?
        LIMIT 1
    ");

    $stmt->execute([$identifiant, $identifiant]);
    $admin = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$admin || !password_verify($password, $admin['mot_de_passe'])) {
        http_response_code(401);
        exit(json_encode([
            'success' => false,
            'message' => 'Identifiant ou mot de passe incorrect'
        ]));
    }

    session_regenerate_id(true);

    $_SESSION['admin_id'] = $admin['id'];
    $_SESSION['admin_nom'] = $admin['nom'];
    $_SESSION['admin_prenom'] = $admin['prenom'];
    $_SESSION['admin_email'] = $admin['email'];

    echo json_encode([
        'success' => true,
        'message' => 'Connexion réussie'
    ]);

} catch (Throwable $e) {
    error_log('Admin login error: ' . $e->getMessage());

    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Erreur serveur pendant la connexion.'
    ]);
}