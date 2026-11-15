<?php
require_once __DIR__ . '/config/db.php';

$stmt = $pdo->prepare("
    SELECT mot_de_passe
    FROM annonceurs
    WHERE nom_utilisateur = ?
    LIMIT 1
");

$stmt->execute(['chriwbie_demo']);
$hash = $stmt->fetchColumn();

if (!$hash) {
    exit("MEMBER NOT FOUND");
}

echo password_verify('Chriwbie@2026', $hash)
    ? "PASSWORD CORRECT"
    : "PASSWORD INCORRECT";