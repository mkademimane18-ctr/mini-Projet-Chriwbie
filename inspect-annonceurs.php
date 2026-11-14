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
    exit("Compte introuvable.");
}

echo "Hash bcrypt détecté : ";
echo password_get_info($hash)['algoName'] . PHP_EOL;

echo "Test password : ";
echo password_verify('chriwbie_demo', $hash)
    ? "CORRECT"
    : "INCORRECT";