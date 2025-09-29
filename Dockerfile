FROM alpine:latest

# Install dependencies and utilities
RUN apk update && apk upgrade && \
    apk add --no-cache zip gosu unzip gnupg supervisor sqlite libpng python3 bind-tools librsvg postgresql-client mysql-client git phpPHP_VERSION-apcu phpPHP_VERSION-bcmath phpPHP_VERSION-cli phpPHP_VERSION-ctype phpPHP_VERSION-curl phpPHP_VERSION-dom phpPHP_VERSION-dbg phpPHP_VERSION-dev phpPHP_VERSION-exif phpPHP_VERSION-fpm phpPHP_VERSION-fileinfo phpPHP_VERSION-gd phpPHP_VERSION-gmp phpPHP_VERSION-iconv phpPHP_VERSION-intl phpPHP_VERSION-ldap phpPHP_VERSION-json phpPHP_VERSION-ldap phpPHP_VERSION-mbstring phpPHP_VERSION-mysqlnd phpPHP_VERSION-odbc phpPHP_VERSION-opcache phpPHP_VERSION-openssl phpPHP_VERSION-pcntl phpPHP_VERSION-pdo phpPHP_VERSION-pgsql phpPHP_VERSION-pdo_mysql phpPHP_VERSION-pgsql phpPHP_VERSION-phar phpPHP_VERSION-posix phpPHP_VERSION-redis phpPHP_VERSION-session phpPHP_VERSION-simplexml phpPHP_VERSION-sockets phpPHP_VERSION-soap phpPHP_VERSION-sodium phpPHP_VERSION-sqlite3 phpPHP_VERSION-sockets phpPHP_VERSION-pecl-protobuf phpPHP_VERSION-pecl-grpc phpPHP_VERSION-pecl-imagick phpPHP_VERSION-pecl-memcache phpPHP_VERSION-pecl-ssh2 phpPHP_VERSION-tidy phpPHP_VERSION-tokenizer phpPHP_VERSION-xml phpPHP_VERSION-xmlreader phpPHP_VERSION-xmlwriter phpPHP_VERSION-zip phpPHP_VERSION-ftp phpPHP_VERSION-imap

COPY composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

RUN [ ! -e /usr/bin/php ] && ln -s /usr/bin/phpPHP_VERSION /usr/bin/php || true && \
    [ ! -e /usr/bin/phpize ] && ln -s /usr/bin/phpizePHP_VERSION /usr/bin/phpize || true && \
    [ ! -e /usr/bin/php-config ] && ln -s /usr/bin/php-configPHP_VERSION /usr/bin/php-config || true

# Set build argument for group
#ARG APPGROUP=1337
#RUN addgroup -g "$APPGROUP" appuser && \
#    adduser -D -u 1337 -G appuser appuser

CMD ["/bin/sh"]
