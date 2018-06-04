FROM alpine:latest

LABEL Maintainer="Serge NOEL <serge.noel@net6a.com>"

# Install needed packages
RUN apk update \
    && apk add nginx php7-fpm php7-gd php7-session php7-simplexml php7-xml zip wget supervisor 

# Prepare for loggin
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /dev/stderr /var/log/fpm.err.log \
    && ln -sf /dev/stdout /var/log/fpm.log

# Get pluxml files (latests)
RUN wget http://telechargements.pluxml.org/download.php -O pluxml.zip 

# Copy configuration files
COPY Files/ /

# Modify access to some files
RUN mkdir -p /var/run/nginx \
    && mkdir /var/www/html \
    && cd /var/www/html \ 
    && unzip /pluxml.zip \
    && mv PluXml/* . \
    && rmdir PluXml \
    && chown nginx: /var/www/html \
    && rm -f /var/www/html/install.php \
    && rm -rf /var/www/html/plugins \ 
    && rm -rf /var/www/html/themes \
    && rm -rf /var/www/html/data/*

# This part must be writeable
VOLUME /var/www/html/data

# Expose http port
EXPOSE 80

# launch supervisor
CMD ["/usr/local/bin/launch-supervisor"]

