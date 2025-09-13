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
# Skip artisan cache clearing to avoid PackageManifest loading
echo "Skipping artisan cache commands to avoid package manifest errors..."

# Set proper permissions first
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Skip database operations to avoid package manifest loading
echo "Skipping database operations to avoid package manifest errors..."

# Skip package discovery and caching for now to avoid errors
echo "Skipping package discovery to avoid manifest errors..."

# Only cache config if absolutely necessary
echo "Skipping config cache to avoid manifest errors..."

echo "Starting Apache..."
exec apache2-foreground
