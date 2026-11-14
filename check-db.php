<?php
require __DIR__ . '/config/db.php';

echo "Database: ";
echo $pdo->query("SELECT DATABASE()")->fetchColumn();
echo PHP_EOL;
