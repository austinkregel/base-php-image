#!/usr/bin/env bash
set -x
set -e

TAG=$PHP_VERSION-$(git rev-parse HEAD | head -c 7)

#docker login -u $DOCKER_USER -p $DOCKER_PASS

export WWWUSER=${WWWUSER:-$UID}
export WWWGROUP=${WWWGROUP:-$(id -g)}

echo "Building base image with PHP version: $PHP_VERSION"

export TAGS=('8.2' '8.3' '8.4')

EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php

if [ $RESULT -ne 0 ]
then
    >&2 echo 'ERROR: Composer installation failed'
    exit 1
fi


for version in "${TAGS[@]}"; do
    export ALPINE_PHP_VERSION=$(echo $version | sed 's/\.//g')

    mkdir -p $version
    cp -r Dockerfile $version/
    cp -r composer.phar $version/
    sed -i "s/PHP_VERSION/$ALPINE_PHP_VERSION/g" $version/Dockerfile
    cd $version

    docker build \
        --build-arg WWWUSER=$WWWUSER \
        --build-arg WWWGROUP=$WWWGROUP \
        --no-cache \
        -t ghcr.io/austinkregel/base:$version .

    docker tag ghcr.io/austinkregel/base:$version ghcr.io/austinkregel/base:php$version
    cd ..
    rm -rfv $version
done

echo "Pushing images..."

for version in "${TAGS[@]}"; do
    docker push ghcr.io/austinkregel/base:$version
    docker push ghcr.io/austinkregel/base:php$version
done

rm -rf composer.phar

echo "Build complete."