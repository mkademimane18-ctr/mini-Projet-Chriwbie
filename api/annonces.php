
<?php

header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../config/db.php';

try {
    $stmt = $pdo->query(
        "SELECT id, titre, description, prix, ville, categorie, photo, date_creation
         FROM annonces
         ORDER BY date_creation DESC"
    );

    echo json_encode(
        $stmt->fetchAll(),
        JSON_UNESCAPED_UNICODE
    );

} catch (PDOException $e) {
    error_log($e->getMessage());
    http_response_code(500);

    echo json_encode([
        'error' => 'Erreur lors du chargement des annonces.'
    ], JSON_UNESCAPED_UNICODE);
}
