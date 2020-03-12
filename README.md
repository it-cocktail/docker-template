# Introduction

## About this template

This template was build to ease the usage of Docker and a containerized LAMP-Stack used for development, testing and
production environments. It uses Kubernetes to deploy the environment.


## Images used

We use the offical MySQL and PHPMyAdmin images without modifications, but with configured volumes.
MySQL has the data Folder in an persistent Folder and init Volumes to initialize the Database on first startup.
The PHPMyAdmin has a custom php.ini exposed, so you can customize it if needed.

The PHP image is a custom image with a lot of functionality explained below.


## PHP Images

We have build custom docker images for php that are available on docker hub. The images use apache mod_php as it has
some advantages over php-fpm and htaccess files can be used easily. A lot of PHP extensions are already included and
also some additional tools that are helpful as wkhtmltopdf, the cron daemon, gnupg, ssh keychain manager or composer.

The images are available with the following php versions: 5.3, 5.5, 5.6, 7.0, 7.1, 7.2, 7.3, 7.4 and every version is additionally
build with xdebug enabled as {version}-debug.


# Instructions

## Installation

* Download the new release tag (**do not checkout master branch**)
* Copy .env-dist to .env and configure it

Configuration in .env:

* `PROJECTNAME`<br />
    projectname for composer stack

* `PHP_VERSION`<br />
    PHP version of web container. (5.3, 5.5, 5.6, 7.0 und 7.1)

* `MYSQL_VERSION`<br />
    MySQL version of DB container. (5.5, 5.7, 8.0)

* `MYSQL_ROOT_PASSWORD`<br />
    MySQL Root Password.

* `MYSQL_PORT`<br />
    Local port to forward to mysql port in pod.

* `PHPMYADMIN_VERSION`<br />
    PHPMyAdmin version used (4.7, 4.8, 4.9, 5.0)

* `ENVIRONMENT`<br />
    Application environment, will be added as APP_ENV, APPLICATION_ENVIRONMENT, TYPO3_CONTEXT and PIMCORE_ENVIRONMENT

* `BASE_DOMAIN`<br />
    Base-Domain of the Application.<br />
    You can use lvh.me for delevopment porposes and every host of this domain resolves to 127.0.0.1<br />
    <br />
    The `BASE_DOMAIN` will be prefixes with the following hosts:
    
    - w<span>ww</span>.[BASE_DOMAIN]
    - phpmyadmin.[BASE_DOMAIN]
    <br /><br />

* `HTDOCS_FOLDER`<br />
    Folder for PHP-Sources

* `DOCUMENT_ROOT`<br />
    Apache Document-Root relative to `HTDOCS_FOLDER`. (i.e. `web` for typo3 or `public` for zf)


## Usage

There are the following commands:

* `./control.cmd start-ingress` (Unix) / `control.cmd start-ingress` (Win)<br />
    start ingress services (only needed on Docker Desktop)
 
* `./control.cmd stop-ingress` (Unix) / `control.cmd stop-ingress` (Win)<br />
    stop ingress services (only needed on Docker Desktop)

* `./control.cmd start` (Unix) / `control.cmd start` (Win)<br />
    start services
 
* `./control.cmd stop` (Unix) / `control.cmd stop` (Win)<br />
    stop services.

* `./control.cmd restart` (Unix) / `control.cmd restart` (Win)<br />
    restart services.

* `./control.cmd console` (Unix) / `control.cmd console` (Win)<br />
    enter the console of the PHP container.

* `./control.cmd mysql` (Unix) / `control.cmd mysql` (Win)<br />
    mysql console command.

* `./control.cmd mysqlconsole` (Unix) / `control.cmd mysqlconsole` (Win)<br />
    enter the console of the MySQL container.

* `./control.cmd php` (Unix) / `control.cmd php` (Win)<br />
    PHP console command.

* `./control.cmd update-crontab` (Unix) / `control.cmd update-crontab` (Win)<br />
    use this command to activate changes made in crontab.


### Cronjobs
The crontab is in the following directory `container/php/crontab.<env>`.
