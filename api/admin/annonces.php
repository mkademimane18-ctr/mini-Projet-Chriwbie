<?php
require_once __DIR__ . '/../../config/db.php';
require_once __DIR__ . '/auth.php';

header('Content-Type: application/json; charset=utf-8');

verifierAdmin();

try {
    $stmt = $pdo->query("
        SELECT
            id,
            titre,
            description,
            prix,
            ville,
            categorie,
            photo,
            date_creation,
            date_fin,
            statut
        FROM annonces
        ORDER BY
            CASE
                WHEN statut = 'En attente' THEN 0
                ELSE 1
            END,
            date_creation DESC
    ");

    $annonces = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode([
        'success' => true,
        'annonces' => $annonces
    ], JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' => 'Erreur lors du chargement des annonces.'
    ]);
}