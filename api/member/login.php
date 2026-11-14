
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
        FROM annonceurs
        WHERE email = ? OR nom_utilisateur = ?
        LIMIT 1
    ");

    $stmt->execute([$identifiant, $identifiant]);
    $membre = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$membre) {
        http_response_code(401);
        exit(json_encode([
            'success' => false,
            'message' => 'Compte membre introuvable dans la base utilisée par le site.'
        ]));
    }

    if (!password_verify($password, $membre['mot_de_passe'])) {
        http_response_code(401);
        exit(json_encode([
            'success' => false,
            'message' => 'Mot de passe incorrect.'
        ]));
    }

    session_regenerate_id(true);
    $_SESSION['membre_id'] = $membre['id'];

    echo json_encode([
        'success' => true,
        'message' => 'Connexion réussie',
        'membre' => [
            'id' => $membre['id'],
            'nom' => $membre['nom'],
            'prenom' => $membre['prenom'],
            'email' => $membre['email'],
            'nom_utilisateur' => $membre['nom_utilisateur']
        ]
    ]);

} catch (Throwable $e) {
    error_log('Member login error: ' . $e->getMessage());

    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Erreur serveur pendant la connexion.'
    ]);
}
