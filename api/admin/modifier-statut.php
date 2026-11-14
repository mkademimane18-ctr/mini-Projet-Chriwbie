<?php
require_once __DIR__ . '/../../config/db.php';
require_once __DIR__ . '/auth.php';

header('Content-Type: application/json; charset=utf-8');

verifierAdmin();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);

    echo json_encode([
        'success' => false,
        'message' => 'Méthode non autorisée.'
    ]);

    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

$id = filter_var(
    $data['id'] ?? null,
    FILTER_VALIDATE_INT
);

$statut = $data['statut'] ?? '';

if (!$id || !in_array($statut, ['Active', 'Refusée'], true)) {
    http_response_code(400);

    echo json_encode([
        'success' => false,
        'message' => 'Données invalides.'
    ]);

    exit;
}

try {
    $stmt = $pdo->prepare("
        UPDATE annonces
        SET statut = :statut
        WHERE id = :id
          AND statut = 'En attente'
    ");

    $stmt->execute([
        ':statut' => $statut,
        ':id' => $id
    ]);

    if ($stmt->rowCount() === 0) {
        http_response_code(404);

        echo json_encode([
            'success' => false,
            'message' => 'Annonce introuvable ou déjà traitée.'
        ]);

        exit;
    }

    echo json_encode([
        'success' => true,
        'message' => $statut === 'Active'
            ? 'Annonce validée avec succès.'
            : 'Annonce refusée avec succès.'
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' => 'Erreur lors de la modification du statut.'
    ]);
}