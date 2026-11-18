<?php

require_once __DIR__ . '/../vendor/autoload.php';

try {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
    $dotenv->safeLoad();
} catch (Throwable $e) {
    error_log('Unable to load database environment configuration.');
    throw new RuntimeException('Database configuration is unavailable.');
}

$readEnvironment = static function (string $name, string $default = ''): string {
    $values = [
        $_ENV[$name] ?? null,
        $_SERVER[$name] ?? null,
        getenv($name),
    ];

    foreach ($values as $value) {
        if ($value === false || $value === null) {
            continue;
        }

        $value = trim((string) $value);
        if ($value !== '') {
            return $value;
        }
    }

    return $default;
};

$host = $readEnvironment('DB_HOST');
$port = $readEnvironment('DB_PORT', '19143');
$dbname = $readEnvironment('DB_NAME', 'chriwbie');
$user = $readEnvironment('DB_USER');
$password = $readEnvironment('DB_PASSWORD');

$missingVariables = [];
foreach (['DB_HOST' => $host, 'DB_USER' => $user, 'DB_PASSWORD' => $password] as $name => $value) {
    if ($value === '') {
        $missingVariables[] = $name;
    }
}

if ($missingVariables !== []) {
    error_log('Database configuration missing variables: ' . implode(', ', $missingVariables) . '.');
    throw new RuntimeException('Database configuration is missing.', 1001);
}

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
} catch (PDOException $e) {
    error_log('MySQL connection failed (SQLSTATE ' . $e->getCode() . ').');
    throw new RuntimeException('MySQL connection failed.', 1002);
}
