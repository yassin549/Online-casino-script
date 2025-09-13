#!/bin/bash

# Set error handling
set -e

# Parse Railway's DATABASE_URL into Laravel's standard DB variables
if [ -n "$DATABASE_URL" ]; then
    echo "Parsing DATABASE_URL..."
    # Extract the protocol
    proto="$(echo $DATABASE_URL | grep '://' | sed -e's,.*://,,g')"
    # Extract the user and password (if any)
    userpass="$(echo $proto | grep @ | cut -d@ -f1)"
    export DB_USERNAME="$(echo $userpass | cut -d: -f1)"
    export DB_PASSWORD="$(echo $userpass | cut -d: -f2)"
    # Extract the host and port
    hostport="$(echo $proto | sed -e 's,.*@,,g' | cut -d/ -f1)"
    export DB_HOST="$(echo $hostport | cut -d: -f1)"
    export DB_PORT="$(echo $hostport | cut -d: -f2)"
    # Extract the database
    export DB_DATABASE="$(echo $proto | cut -d/ -f2 | cut -d? -f1)"
    export DB_CONNECTION="mysql"
fi

# Set up directories and permissions first
echo "Setting up directories and permissions..."
mkdir -p /var/www/html/storage/framework/sessions /var/www/html/storage/framework/views /var/www/html/storage/framework/cache /var/www/html/storage/logs /var/www/html/bootstrap/cache

# Generate application key if not set
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "" ]; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

# Create a dummy package manifest to prevent discovery errors
echo "Creating dummy package manifest..."
echo '<?php return [];' > bootstrap/cache/packages.php

# Now, safely clear and cache the configuration
echo "Clearing and caching configuration..."
php artisan config:clear
php artisan config:cache

# Wait for database to be ready
echo "Waiting for database connection..."
until php artisan migrate:status > /dev/null 2>&1; do
    echo "Database not ready, waiting..."
    sleep 2
done

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Ensure laravel.log exists
touch /var/www/html/storage/logs/laravel.log

# Set final ownership for all generated files
echo "Setting final ownership..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo "Starting Apache..."
exec apache2-foreground
