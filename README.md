# Instructions

## Installation

* Download the new release tag (**do not checkout master branch**)
* Copy .env-dist to .env and configure it
* Copy docker-data/config-dist to docker-data/config and configure it if necessary
* The Docker-Proxy should be started before using this template (http://gitlab.orangehive.de/orangehive/docker-proxy)

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
    You can use lvh.me for delevopment porposes and all host of the domain resolve to 127.0.0.1<br />
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
