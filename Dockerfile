FROM alpine:latest

LABEL Maintainer="Serge NOEL <serge.noel@net6a.com>"

RUN apk update \
    && apk add nginx php7-fpm php7-gd php7-session php7-simplexml php7-xml zip wget supervisor 

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /dev/stderr /var/log/fpm.err.log \
    && ln -sf /dev/stdout /var/log/fpm.log

RUN mkdir -p /var/run/nginx

RUN wget http://telechargements.pluxml.org/download.php -O pluxml.zip 

COPY Files/ /
#COPY nginx.conf /etc/nginx/nginx.conf
#COPY php-fpm.conf /etc/php7/php-fpm.conf
#COPY www.conf /etc/php7/php-fpm.d/www.conf
#COPY data.tgz /var/www/data.tgz

RUN mkdir /var/www/html \
    && cd /var/www/html \ 
    && unzip /pluxml.zip \
    && mv PluXml/* . \
    && rmdir PluXml \
    && chown nginx: /var/www/html \
    && rm -f /var/www/html/install.php \
    && rm -rf /var/www/html/plugins \ 
    && rm -rf /var/www/html/themes \
    && rm -rf /var/www/html/data/*

# Essai
VOLUME /var/www/html/data

EXPOSE 80

CMD ["/usr/local/bin/launch-supervisor"]

