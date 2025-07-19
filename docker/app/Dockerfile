FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    postgresql-dev \
    supervisor \
    dcron \
    bash \
    nano \
    vim \
    autoconf \
    gcc \
    g++ \
    make \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

# Install Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
ARG uid=1000
ARG user=laravel
RUN addgroup -g $uid $user && \
    adduser -D -s /bin/bash -u $uid -G $user $user

# Create composer directory and set permissions
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=$user:$user . /var/www

# Create log directories
RUN mkdir -p /var/www/storage/logs && \
    chown -R $user:$user /var/www/storage/logs

# Change current user to laravel
USER $user

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"] 