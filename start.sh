#!/bin/bash

# Set error handling
set -e

echo "Starting Laravel application setup..."

# Generate application key if not set
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "" ]; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

# Clear any existing cache
echo "Clearing cache..."
php artisan config:clear || true
php artisan cache:clear || true
php artisan view:clear || true
php artisan route:clear || true

# Set proper permissions first
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Check if database is available (optional for startup)
echo "Checking database connection..."
if php artisan tinker --execute="try { DB::connection()->getPdo(); echo 'DB OK'; } catch(Exception \$e) { echo 'DB Error: ' . \$e->getMessage(); }" 2>/dev/null | grep -q "DB OK"; then
    echo "Database connected, running migrations..."
    php artisan migrate --force || echo "Migration failed, continuing..."
else
    echo "Database not available, skipping migrations..."
fi

# Discover packages
echo "Discovering packages..."
php artisan package:discover || echo "Package discovery failed, continuing..."

# Cache configurations (only if no errors)
echo "Caching configurations..."
php artisan config:cache || echo "Config cache failed, continuing..."

echo "Starting Apache..."
exec apache2-foreground
