#!/bin/sh
set -e

DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"

echo "Waiting for database at ${DB_HOST}:${DB_PORT}..."
until php -r '
$host = getenv("DB_HOST") ?: "db";
$port = (int) (getenv("DB_PORT") ?: 3306);
$conn = @fsockopen($host, $port, $errno, $errstr, 2);
if (!$conn) { exit(1); }
fclose($conn);
'; do
    sleep 2
done
echo "Database is reachable."

echo "Running phinx migrations..."
php vendor/bin/phinx migrate

echo "Running phinx seeds..."
php vendor/bin/phinx seed:run || echo "Seed run skipped/failed (likely already seeded); continuing."

echo "Starting application..."
exec "$@"
