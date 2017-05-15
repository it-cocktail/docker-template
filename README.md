# Introduction

## About this template

This template was build to ease the usage of Docker and a containerized LAMP-Stack used for development, testing and
production environments. It consist out of up to 4 services building a docker compose stack.


## Images used

We use the offical MySQL and PHPMyAdmin images without modifications, but with configured volumes.
MySQL has the data Folder in an persistent Folder and init Volumes to initialize the Database on first startup.
The PHPMyAdmin has a custom php.ini exposed, so you can customize it if needed.

In development mode we use Mailhog to intercept every mail send by the php application for debugging and testing purposes.

The PHP image is a custom image with a lot of functionality explained below.


## PHP Images

We have build custom docker images for php that are available on docker hub. The images use apache mod_php as it has
some advantages over php-fpm and htaccess files can be used easily. A lot of PHP extensions are already included and
also some additional tools that are helpful as wkhtmltopdf, the cron daemon, gnupg, ssh keychain manager or composer.

The images are available with the following php versions: 5.3, 5.5, 5.6, 7.0 and 7.1 and every version is additionally
build with xdebug enabled as {version}-debug.


## Debugging

For debugging purposes we added the -d parameter to the start script that automatically sets the local IP for xdebug so
step-by-step debugging is as easy as never before.


## Nginx Proxy

The template needs our docker-proxy that adds an nginx proxy for multiple template projects
and an ELK-Stack for easy logging.<br />
It can be found here: (https://github.com/orange-hive/docker-proxy)


# Instructions

## Installation

* Download the new release tag (**do not checkout master branch**)
* Copy .env-dist to .env and configure it
* Copy docker-data/config-dist to docker-data/config and configure it if necessary
* The Docker-Proxy should be started before using this template (https://github.com/orange-hive/docker-proxy.git)

Configuration in .env:

* `PROJECTNAME`<br />
    projectname for composer stack

* `PHP_VERSION`<br />
    PHP version of web container. (5.3, 5.5, 5.6, 7.0 und 7.1)

* `MYSQL_VERSION`<br />
    MySQL version of DB container. (5.5 und 5.7)

* `MYSQL_ROOT_PASSWORD`<br />
    MySQL Root Password.

* `PHPMYADMIN_VERSION`<br />
    PHPMyAdmin version used (4.7 seems to be buggy, use 4.6)

* `AUTOPULL`<br />
    Automatically pull newer docker images on startup

* `ENVIRONMENT`<br />
    Application environment, will be added as APP_ENV, APPLICATION_ENVIRONMENT and TYPO3_CONTEXT

* `BASE_DOMAIN`<br />
    Base-Domain of the Application.<br />
    You can use lvh.me for delevopment porposes and every host of this domain resolves to 127.0.0.1<br />
    <br />
    The `BASE_DOMAIN` will be prefixes with the following hosts:
    
    - w<span>ww</span>.[BASE_DOMAIN]
    - phpmyadmin.[BASE_DOMAIN]
    - mailhog.[BASE_DOMAIN] or mail.[BASE_DOMAIN]
    - java.[BASE_DOMAIN], if `JAVA_SRC_FOLDER` exists
    <br /><br />

* `HTDOCS_FOLDER`<br />
    Folder for PHP-Sources

* `DOCUMENT_ROOT`<br />
    Apache Document-Root relative to `HTDOCS_FOLDER`. (i.e. `web` for typo3 or `public` for zf)

* `JAVA_SRC_FOLDER`<br />
    The java source folder.<br />
    The has to be a build.xml Ant script with target `run`.

* `JAVA_OPTS`<br />
    Options for JVM<br />
    Example: `-Xmx1024m -XX:MaxPermSize=256m`

* `JAVA_ANT_OPTS`<br />
    Options for JVM used by Ant<br />
    Example: `-Xmx1024m -XX:MaxPermSize=256m`


## Usage

There are the following commands:

* `./control.cmd start` (Unix) / `control.cmd start` (Win)<br />
    start services
 
* `./control.cmd stop` (Unix) / `control.cmd stop` (Win)<br />
    stop services.

* `./control.cmd pull` (Unix) / `control.cmd pull` (Win)<br />
    download new container images if available.

* `./control.cmd compass` (Unix) / `control.cmd compass` (Win)<br />
    compass console command.

* `./control.cmd composer` (Unix) / `control.cmd composer` (Win)<br />
    composer command. Will be executed with the configured PHP version.

* `./control.cmd console` (Unix) / `control.cmd console` (Win)<br />
    enter the console of the PHP container.

* `./control.cmd mysql` (Unix) / `control.cmd mysql` (Win)<br />
    mysql console command.

* `./control.cmd mysqlconsole` (Unix) / `control.cmd mysqlconsole` (Win)<br />
    enter the console of the MySQL container.

* `./control.cmd mysqldump` (Unix) / `control.cmd mysqldump` (Win)<br />
    mysqldump console command.

* `./control.cmd php` (Unix) / `control.cmd php` (Win)<br />
    PHP console command.

* `./control.cmd update-crontab` (Unix) / `control.cmd update-crontab` (Win)<br />
    use this command to activate changes made in crontab.

* `./control.cmd rebuild-java` (Unix) / `control.cmd rebuild-java` (Win)<br />
    rebuild java with ant.

* `./control.cmd update-docker-template` (Unix) / `control.cmd update-docker-template` (Win)<br />
    update this template


### Cronjobs
The crontab is in the following directory `docker-data/config/container/php/cron/crontab`.
