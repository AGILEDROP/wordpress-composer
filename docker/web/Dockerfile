FROM php:7.2-apache

ENV APACHE_DOCUMENT_ROOT /var/www/wp
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite headers
ENV INSTALL_DIR /usr/local
RUN chown -R www-data:www-data $INSTALL_DIR
RUN apt-get update && \
    apt-get install -y default-mysql-client libxml2-dev libmcrypt4 libmcrypt-dev libpng-dev libjpeg-dev libfreetype6 libfreetype6-dev less
RUN docker-php-ext-install soap
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/lib/ --with-freetype-dir=/usr/lib/ && \
    docker-php-ext-install gd
RUN apt-get update && \
    apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git && \
    rm -rf /var/lib/apt/lists/*
RUN pecl install xdebug
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
RUN echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'xdebug.remote_host=10.254.254.254' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'xdebug.idekey=PHPSTORM_DRUPAL' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'xdebug.remote_autostart=1' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'memory_limit=-1' >> /usr/local/etc/php/conf.d/z-custom.ini
RUN echo 'max_execution_time=0' >> /usr/local/etc/php/conf.d/z-custom.ini

WORKDIR /var/www