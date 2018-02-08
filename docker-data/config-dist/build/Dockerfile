FROM fduarte42/docker-php:{{php_version}}

ENV VIRTUAL_PORT 80
ENV VIRTUAL_HOST "phpmyadmin.{{base_domain}}, {{php_virtual_host}}"
ENV APACHE_HOST "www.{{base_domain}}"
ENV APACHE_ALIAS "{{php_apache_alias}}"
ENV BASE_DOMAIN "{{base_domain}}"
ENV DOCUMENT_ROOT "{{document_root}}"
ENV APP_ENV "{{environment}}"
ENV APPLICATION_ENVIRONMENT "{{environment}}"
ENV TYPO3_CONTEXT "{{environment}}"
ENV PHPMYADMIN_RESTRICTION "{{phpmyadmin_restriction}}"

COPY docker-data/config/container/php/php.ini /usr/local/etc/php/conf.d/zzz-custom.ini
COPY docker-data/config/container/php/apache2/sites-enabled/ /etc/apache2/sites-enabled/
COPY docker-data/config/container/php/ssmtp/ssmtp.production.conf /etc/ssmtp/ssmtp.conf
COPY docker-data/config/container/php/ssh/ /ssh/
COPY docker-data/config/container/php/cron/crontab /tmp/crontab
COPY .env /etc/environment
COPY "{{htdocs_folder}}/*" /var/www/html/

VOLUME ["/var/www/html"]

WORKDIR /var/www/html

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
