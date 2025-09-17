#!/bin/bash
mkdir -p /run/php-fpm
mkdir -p /home/edocs
chmod 0777 /home/edocs
/usr/sbin/postfix start
# Start PHP-FPM in the background
php-fpm
# Start HTTPD in the foreground
httpd -DFOREGROUND
