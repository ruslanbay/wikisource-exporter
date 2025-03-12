FROM ubuntu:24.04

# Build arguments for metadata
ARG BUILD_DATE="2025-03-12T18:51:07Z"
ARG BUILD_VERSION="3.1.0"
ARG GITHUB_USER="ruslanbay"

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
RUN git clone --depth 1 --branch ${BUILD_VERSION} https://github.com/wikimedia/ws-export.git . && \
    composer install --no-dev --no-interaction --prefer-dist && \
    # Setup database directory
    mkdir -p var && \
    chmod 777 var && \
    # Setup environment configuration
    cp .env .env.local && \
    sed -i 's#DATABASE_URL=.*#DATABASE_URL=sqlite://%kernel.project_dir%/var/app.db#' .env.local

# Create a wrapper script for the app
RUN printf '#!/bin/sh\n\
mkdir -p /github/workspace/output\n\
php ./bin/console app:export \\\n\
  $([ "$4" = "true" ] && echo "--nocredits") \\\n\
  $([ "$5" = "true" ] && echo "--nocache") \\\n\
  --lang "$2" \\\n\
  --format "$3" \\\n\
  --title "$1" \\\n\
  --output "/github/workspace/output/" \n\
echo "output-path=/github/workspace/output" >> $GITHUB_OUTPUT\n' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set metadata labels using build arguments
LABEL org.opencontainers.image.title="WikiSource Exporter" \
      org.opencontainers.image.description="Container for WikiSource Exporter" \
      org.opencontainers.image.source="https://github.com/${GITHUB_USER}/wikisource-exporter" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.version="${BUILD_VERSION}" \
      org.opencontainers.image.ref.name="${BUILD_VERSION}" \
      org.opencontainers.image.licenses="GPL-3.0" \
      org.opencontainers.image.vendor="${GITHUB_USER}" \
      org.opencontainers.image.authors="${GITHUB_USER}"

ENTRYPOINT ["/entrypoint.sh"]