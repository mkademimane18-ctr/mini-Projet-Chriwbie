<?php
require_once __DIR__ . '/config/db.php';

$newPassword = 'Chriwbie@2026';
$hash = password_hash($newPassword, PASSWORD_BCRYPT);

$stmt = $pdo->prepare("
    UPDATE annonceurs
    SET mot_de_passe = ?
    WHERE nom_utilisateur = ?
");

$stmt->execute([$hash, 'chriwbie_demo']);

echo $stmt->rowCount() > 0
    ? "Mot de passe mis à jour."
    : "Aucune modification effectuée.";