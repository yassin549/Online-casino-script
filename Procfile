web: php -S 0.0.0.0:$PORT -t public/
release: php artisan key:generate --force && php artisan migrate --force && php artisan config:cache && php artisan package:discover
 