<?php

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (str_starts_with($path, '/api/')) {
    $file = __DIR__ . $path;

    if (is_file($file) && str_ends_with($file, '.php')) {
        require $file;
        return true;
    }

    http_response_code(404);
    echo json_encode(['success' => false, 'message' => 'API introuvable']);
    return true;
}

$file = __DIR__ . '/public' . $path;

if ($path !== '/' && is_file($file)) {
    return false;
}

if ($path === '/') {
    $file = __DIR__ . '/public/index.html';
    if (is_file($file)) {
        require $file;
        return true;
    }
}

http_response_code(404);
echo 'Page introuvable';
return true;