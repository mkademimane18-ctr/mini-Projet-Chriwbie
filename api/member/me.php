<?php
require_once __DIR__ . '/auth.php';
header('Content-Type: application/json; charset=utf-8');

if (empty($_SESSION['membre_id'])) {
    http_response_code(401);
    exit(json_encode(['success' => false, 'message' => 'Non connecté']));
}

require_once __DIR__ . '/../../config/db.php';

$stmt = $pdo->prepare("
    SELECT id, nom, prenom, email, nom_utilisateur, type_annonceur,
           nom_entreprise, adresse, ville, telephone, site_web
    FROM annonceurs
    WHERE id = ?
    LIMIT 1
");
$stmt->execute([$_SESSION['membre_id']]);
$membre = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$membre) {
    unset($_SESSION['membre_id']);
    http_response_code(401);
    exit(json_encode(['success' => false, 'message' => 'Compte introuvable']));
}

echo json_encode(['success' => true, 'membre' => $membre]);
