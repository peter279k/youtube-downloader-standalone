#!/bin/bash

php_version=$1

git clone https://github.com/Athlon1600/youtube-downloader

cd youtube-downloader/

curl -JL https://clue.engineering/phar-composer-latest.phar -o phar-composer.phar

for tag_name in $(git tag)
do
    git checkout $tag_name
    composer update -n
    if [[ ! -d "../$tag_name" ]]; then
        mkdir "../$tag_name"
        mkdir "../$tag_name/php-$php_version"
    else
        if [[ ! -d "../$tag_name/php-$php_version" ]]; then
            mkdir "../$tag_name/php-$php_version"
        fi;
    fi;
    php ./phar-composer.phar build ./ 2>&1 > /dev/null
    cp youtube-downloader.phar "../$tag_name/php-$php_version/"
    rm -f youtube-downloader.phar
    if [[ $? == 0 ]]; then
        echo "Builidng $tag_name with PHP-$php_version has been done."
    else
        echo "Building $tag_name with PHP-$php_version has been failed!"
    fi;
done;

tag_name="master"
git checkout $tag_name
composer update -n
if [[ ! -d "../$tag_name" ]]; then
    mkdir "../$tag_name"
    mkdir "../$tag_name/php-$php_version"
else
    if [[ ! -d "../$tag_name/php-$php_version" ]]; then
        mkdir "../$tag_name/php-$php_version"
    fi;
fi;

php ./phar-composer.phar build ./ 2>&1 > /dev/null
cp youtube-downloader.phar "../$tag_name/php-$php_version/"
rm -f youtube-downloader.phar
if [[ $? == 0 ]]; then
    echo "Builidng $tag_name with PHP-$php_version has been done."
else
    echo "Building $tag_name with PHP-$php_version has been failed!"
fi;
