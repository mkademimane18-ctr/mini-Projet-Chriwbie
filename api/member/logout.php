<?php
require_once __DIR__ . '/auth.php';
header('Content-Type: application/json; charset=utf-8');

unset($_SESSION['membre_id']);
session_regenerate_id(true);

echo json_encode(['success' => true, 'message' => 'Déconnexion réussie']);
