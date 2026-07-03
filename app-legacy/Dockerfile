FROM composer:2 AS composer

FROM php:7.4-cli

RUN apt-get update && apt-get install -y --no-install-recommends \
        libzip-dev \
        unzip \
        default-mysql-client \
    && docker-php-ext-install pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www

# Composer's autoload-dev classmap scans database/ at install time, so the
# full source must be present before running install (no composer.json-only
# caching layer here). --no-scripts skips the post-install .env bootstrap
# (upstream composer.json script); DB config is injected via docker-compose
# environment variables instead (see docker-compose.yml). Dev deps are kept
# (no --no-dev): phinx's migration_base_class "BaseMigration" is only
# classmap-autoloaded under autoload-dev in the upstream composer.json, so
# migrations fail without it.
COPY . .
RUN COMPOSER_NO_BLOCKING=1 composer install --no-interaction --no-scripts --no-progress

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php", "-S", "0.0.0.0:8080", "-t", "public", "public/index.php"]
