#!/bin/bash

# Railway deployment script for Laravel Casino Platform
echo "Starting Railway deployment..."

# Remove composer.lock to allow fresh dependency resolution
if [ -f "composer.lock" ]; then
    echo "Removing composer.lock for fresh dependency resolution..."
    rm composer.lock
fi

# Install dependencies with platform requirements ignored
echo "Installing composer dependencies..."
composer update --no-dev --optimize-autoloader --ignore-platform-reqs

# Generate application key if not exists
echo "Generating application key..."
php artisan key:generate --force

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Seed database if needed
echo "Seeding database..."
php artisan db:seed --force

# Cache configuration for production
echo "Caching configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Deployment completed successfully!"
