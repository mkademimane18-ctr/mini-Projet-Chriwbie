
<?php

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Méthode non autorisée']);
    exit;
}

require_once __DIR__ . '/../config/db.php';

$data = json_decode(file_get_contents('php://input'), true) ?? [];

$titre = trim($data['titre'] ?? '');
$description = trim($data['description'] ?? '');
$prix = $data['prix'] ?? null;
$ville = trim($data['ville'] ?? '');
$categorie = trim($data['categorie'] ?? '');
$photo = trim($data['photo'] ?? '');

if ($titre === '') {
    http_response_code(400);
    echo json_encode(['error' => 'Le titre est obligatoire']);
    exit;
}

try {
    $sql = "INSERT INTO annonces
            (titre, description, prix, ville, categorie, photo)
            VALUES (:titre, :description, :prix, :ville, :categorie, :photo)";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        'titre' => $titre,
        'description' => $description,
        'prix' => $prix !== null && $prix !== '' ? $prix : null,
        'ville' => $ville,
        'categorie' => $categorie,
        'photo' => $photo
    ]);

    http_response_code(201);
    echo json_encode([
        'success' => true,
        'id' => $pdo->lastInsertId()
    ]);

} catch (PDOException $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['error' => 'Erreur lors de l’ajout de l’annonce']);
}
