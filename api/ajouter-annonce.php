<?php

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Méthode non autorisée'], JSON_UNESCAPED_UNICODE);
    exit;
}

require_once __DIR__ . '/../config/db.php';

$rawBody = file_get_contents('php://input');
$data = json_decode($rawBody, true);

// Keep JSON as the primary API format while accepting traditional local form posts.
if (!is_array($data)) {
    $data = $_POST;
}

$titre = trim((string) ($data['titre'] ?? ''));
$description = trim((string) ($data['description'] ?? ''));
$prix = $data['prix'] ?? null;
$ville = trim((string) ($data['ville'] ?? ''));
$categorie = trim((string) ($data['categorie'] ?? ''));
$photo = trim((string) ($data['photo'] ?? ''));

if ($titre === '') {
    http_response_code(400);
    echo json_encode(['error' => 'Le titre est obligatoire'], JSON_UNESCAPED_UNICODE);
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

    if ($stmt->rowCount() !== 1) {
        throw new RuntimeException('Insertion annonce sans ligne affectée.');
    }

    http_response_code(201);
    echo json_encode([
        'success' => true,
        'id' => $pdo->lastInsertId()
    ], JSON_UNESCAPED_UNICODE);

} catch (Throwable $e) {
    error_log(sprintf(
        'Échec publication annonce (%s): %s',
        get_class($e),
        $e->getMessage()
    ));
    http_response_code(500);
    echo json_encode(['error' => 'Erreur lors de l’enregistrement de l’annonce.'], JSON_UNESCAPED_UNICODE);
}
