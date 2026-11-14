<?php

require_once __DIR__ . '/../../config/db.php';
require_once __DIR__ . '/auth.php';

header('Content-Type: application/json; charset=utf-8');

verifierAdmin();

try {
    $stmt = $pdo->query("
        SELECT
            COUNT(*) AS total,
            SUM(statut = 'Active') AS active,
            SUM(statut = 'Expirée') AS expiree,
            SUM(statut = 'En attente') AS attente,
            SUM(statut = 'Refusée') AS refusee
        FROM annonces
    ");

    $stats = $stmt->fetch(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'stats' => [
            'total' => (int) $stats['total'],
            'active' => (int) $stats['active'],
            'expiree' => (int) $stats['expiree'],
            'attente' => (int) $stats['attente'],
            'refusee' => (int) $stats['refusee']
        ]
    ]);

} catch (PDOException $e) {
    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' => 'Erreur lors du chargement des statistiques.'
    ]);
}
