
<?php

require_once __DIR__ . '/../vendor/autoload.php';

ini_set('display_errors', '0');
ini_set('log_errors', '1');

try {
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/..');
    $dotenv->safeLoad();
} catch (Throwable $e) {
    error_log('Unable to load database environment configuration.');

    throw new RuntimeException(
        'Database configuration is unavailable.',
        1001,
        $e
    );
}

$readEnvironment = static function (
    string $name,
    string $default = ''
): string {
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

foreach ([
    'DB_HOST' => $host,
    'DB_USER' => $user,
    'DB_PASSWORD' => $password
] as $name => $value) {
    if ($value === '') {
        $missingVariables[] = $name;
    }
}

if ($missingVariables !== []) {
    error_log(
        'Missing database variables: ' .
        implode(', ', $missingVariables)
    );

    throw new RuntimeException(
        'Database configuration is missing.',
        1001
    );
}

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4";

    $options = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ];

    // Aiven SSL certificate
    $caPath = __DIR__ . '/../certs/ca.pem';

    if (!is_file($caPath)) {
        throw new RuntimeException(
            'Aiven CA certificate not found.'
        );
    }

    // PHP 8.5 compatible SSL options
    if (defined('Pdo\\Mysql::ATTR_SSL_CA')) {
        $options[constant('Pdo\\Mysql::ATTR_SSL_CA')] = $caPath;
        $options[constant('Pdo\\Mysql::ATTR_SSL_VERIFY_SERVER_CERT')] = true;
    } else {
        // Compatibility with older PHP versions
        $options[PDO::MYSQL_ATTR_SSL_CA] = $caPath;
        $options[PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT] = true;
    }

    $pdo = new PDO(
        $dsn,
        $user,
        $password,
        $options
    );

} catch (Throwable $e) {
    error_log(
        'Database connection failed: ' .
        get_class($e) . ' / ' .
        $e->getMessage()
    );

    throw new RuntimeException(
        'Database connection is unavailable.',
        1002,
        $e
    );
}

