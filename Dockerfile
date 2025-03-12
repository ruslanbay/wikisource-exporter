FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    COMPOSER_ALLOW_SUPERUSER=1

# Install required packages
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    --no-install-suggests \
    php-cli \
    php-intl \
    php-sqlite3 \
    php-zip \
    php-curl \
    php-sysvsem \
    php-xml \
    calibre \
    fontconfig \
    fonts-dejavu \
    composer \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone specific version of ws-export and setup the application
RUN git clone --depth 1 --branch 3.1.0 https://github.com/wikimedia/ws-export.git . && \
    # Install composer dependencies
    composer install --no-dev --no-interaction --prefer-dist && \
    # Setup database directory
    mkdir -p var && \
    chmod 777 var && \
    # Setup environment configuration
    cp .env .env.local && \
    sed -i 's#DATABASE_URL=.*#DATABASE_URL=sqlite://%kernel.project_dir%/var/app.db#' .env.local

# Set the maintainer label
LABEL org.opencontainers.image.source=https://github.com/ruslanbay/wikisource-exporter \
      org.opencontainers.image.description="Container for WikiSource Exporter" \
      org.opencontainers.image.licenses=GPL-3.0 \
      org.opencontainers.image.version="3.1.0" \
      org.opencontainers.image.ref.name="3.1.0" \
      org.opencontainers.image.title="WikiSource Exporter" \
      org.opencontainers.image.vendor="ruslanbay"