<?php

header('Content-Type: application/json; charset=utf-8');

try {
    require_once __DIR__ . '/../config/db.php';

    $stmt = $pdo->query(
        "SELECT id, titre, description, prix, ville, categorie, photo, date_creation
         FROM annonces
         ORDER BY date_creation DESC"
    );

    echo json_encode(
        $stmt->fetchAll(),
        JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE
    );
} catch (Throwable $e) {
    error_log('Announcements endpoint failed (' . get_class($e) . ').');
    http_response_code(503);
    echo json_encode([
        'error' => 'Service annonces indisponible.'
    ], JSON_UNESCAPED_UNICODE);
}
