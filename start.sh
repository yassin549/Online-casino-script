#!/bin/bash

# Set error handling
set -e

echo "Starting Laravel application setup..."

# Generate application key if not set
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "" ]; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

# Clear any existing cache and package manifest aggressively
echo "Clearing cache and package manifest..."
rm -f bootstrap/cache/packages.php || true
rm -f bootstrap/cache/services.php || true
rm -f bootstrap/cache/config.php || true
rm -f bootstrap/cache/*.php || true
# Force clear and recache configuration to use new DATABASE_URL
echo "Clearing and caching configuration..."
php artisan config:clear
php artisan config:cache

# Set proper permissions first
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Wait for database to be ready
echo "Waiting for database connection..."
until php artisan migrate:status > /dev/null 2>&1; do
    echo "Database not ready, waiting..."
    sleep 2
done

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Ensure laravel.log exists and has correct permissions
echo "Ensuring laravel.log exists and has correct permissions..."
touch /var/www/html/storage/logs/laravel.log
chown www-data:www-data /var/www/html/storage/logs/laravel.log
chmod 664 /var/www/html/storage/logs/laravel.log

# Create basic packages manifest to prevent errors
echo "Creating basic packages manifest..."
echo '<?php return ["providers" => [], "eager" => [], "deferred" => []];' > bootstrap/cache/packages.php

echo "Starting Apache..."
exec apache2-foreground
