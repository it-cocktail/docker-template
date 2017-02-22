# Anleitung

## Installation

* Das aktulle Release unter Tags herunterladen (**nicht auschecken**)
* Die Datei .env-dist nach .env kopieren und anpassen (**mindestens die `BASE_DOMAIN`**)
* Das Verzeichnis docker-data/config-dist nach docker-data/config kopieren und anpassen falls nötig
* Der Docker Proxy sollten vorher gestartet sein. (http://gitlab.orangehive.de/orangehive/docker-proxy)

Folgende Einstellungsmöglichkeiten gibt es:

* `PROJECTNAME`<br />
    Der Projektname für die Container (falls leer, wird der Verzeichnisname genommen)

* `PHP_VERSION`<br />
    Die PHP-Version des Web-Containers. (5.3, 5.5, 5.6, 7.0 und 7.1 sind möglich)

* `MYSQL_VERSION`<br />
    Die MySQL-Version der Datenbank-Containers. (5.5 und 5.7 sind möglich)

* `MYSQL_ROOT_PASSWORD`<br />
    Das MySQL Root Password.

* `BASE_DOMAIN`<br />
    Die Basis-Domain für diese Application.<br />
    Im DNS gehen alle Einträge unterhalb von *.local.orangehive.de auf localhost und können automatisch ohne Hosts-Eintrag genutzt werden.<br />
    <br />
    Es gibt folgende Hosts die automatisch der `BASE_DOMAIN` vorangestellt werden:
    
    - w<span>ww</span>.[BASE_DOMAIN]
    - phpmyadmin.[BASE_DOMAIN]
    - mailhog.[BASE_DOMAIN] bzw. mail.[BASE_DOMAIN]
    - java.[BASE_DOMAIN], falls der `JAVA_SRC_FOLDER` existiert
    <br /><br />

* `SECONDARY_DOMAIN`<br />
    Die zweite Domain für diese Application.<br />
    Sie wird genauso eingerichtet wie die `BASE_DOMAIN`, ist aber zusätzlich aktiv.

* `HTDOCS_FOLDER`<br />
    Der htdocs Folder in dem die PHP-Sourcen liegen.

* `DOCUMENT_ROOT`<br />
    Der Apache Document-Root relativ zum `HTDOCS_FOLDER`. (z.B. `web` für typo3 oder `public` für zend)

* `JAVA_SRC_FOLDER`<br />
    Das Verzeichnis in dem der Java-Quelltext liegt.<br />
    Es muss ein build.xml Ant script im Verzeichnis liegen mit den target `run`.

* `JAVA_OPTS`<br />
    Optionen die an die JVM weitergegeben werden<br />
    Beispiel: `-Xmx1024m -XX:MaxPermSize=256m`

* `JAVA_ANT_OPTS`<br />
    Optionen die an die JVM beim bauen mit Ant weitergegeben werden<br />
    Beispiel: `-Xmx1024m -XX:MaxPermSize=256m`

## Betrieb

Alle Kommandos befinden sich im Verzeichnis `bin`.

Folgende Kommandos gibt es:

* `./control.cmd start` (OSX) / `control.cmd start` (Win)<br />
    Zum starten der Services. Mit dem Parameter `-d` wird die XDebug Extension aktiviert.
 
* `./control.cmd stop` (OSX) / `control.cmd stop` (Win)<br />
    Zum Beenden der Services.
  
* `./control.cmd compass` (OSX) / `control.cmd compass` (Win)<br />
    Das Compass Konsolen Kommando.

* `./control.cmd composer` (OSX) / `control.cmd composer` (Win)<br />
    Das Composer Konsolen Kommando. Es wird mit der eingestellten PHP Version ausgeführt.

* `./control.cmd console` (OSX) / `control.cmd console` (Win)<br />
    Mit diesem Kommando kommt man in die Bash des PHP Containers.

* `./control.cmd mysql` (OSX) / `control.cmd mysql` (Win)<br />
    Das mysql Konsolen Kommando.

* `./control.cmd mysqlconsole` (OSX) / `control.cmd mysqlconsole` (Win)<br />
    Das mysqldump Konsolen Kommando.

* `./control.cmd mysqldump` (OSX) / `control.cmd mysqldump` (Win)<br />
    Das mysqldump Konsolen Kommando.

* `./control.cmd php` (OSX) / `control.cmd php` (Win)<br />
    Das PHP Konsolen Kommando.

* `./control.cmd showlogs` (OSX) / `control.cmd showlogs` (Win)<br />
    Anzeigen von Logausgaben der Dienste. Ohne Parameter werden alle Dienst angezeigt. Man kann den Dienstnamen als Parameter übergeben und bekommt dann nur dies Logausgaben angezeigt.<br />
    <br />
    Folgende Dienste sind möglich: db, phpmyadmin, mail, php, java

* `./control.cmd update-crontab` (OSX) / `control.cmd update-crontab` (Win)<br />
    Wenn das crontab-File geändert wurde, dann können die Änderungen mit diesem Kommand aktiviert werden

* `./control.cmd rebuild-java` (OSX) / `control.cmd rebuild-java` (Win)<br />
    Das rebuilden des java-Services kann mit diesem Kommando gestartet werden.

* `./control.cmd update-docker-template` (OSX) / `control.cmd update-docker-template` (Win)<br />
    Aktualisiert dieses System


### Cronjobs
Im Verzeichnis `docker-data/config/container/php/cron/crontab` liegt die crontab in der Cronjobs eingerichtet werden können.
