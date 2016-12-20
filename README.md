# Anleitung

## Installation

* Das aktulle Release unter Tags herunterladen (**nicht auschecken**)
* Die Datei .env-dist nach .env kopieren und anpassen (**mindestens die `BASE_DOMAIN`**)

Folgende Einstellungsmöglichkeiten gibt es:

* `PROXY_PORT`<br />
    Der Port für den Proxy unter dem Web-Container erreichbar sind

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

* `bin/start.cmd` (OSX) / `bin\start.cmd` (Win)<br />
    Zum starten der Services. Mit dem Parameter `-d` wird die XDebug Extension aktiviert.
 
* `bin/stop.cmd` (OSX) / `bin\stop.cmd` (Win)<br />
    Zum Beenden der Services.
  
* `bin/compass.cmd` (OSX) / `bin\compass.cmd` (Win)<br />
    Das Compass Konsolen Kommando.

* `bin/composer.cmd` (OSX) / `bin\composer.cmd` (Win)<br />
    Das Composer Konsolen Kommando. Es wird mit der eingestellten PHP Version ausgeführt.

* `bin/console.cmd` (OSX) / `bin\console.cmd` (Win)<br />
    Mit diesem Kommando kommt man in die Bash des PHP Containers.

* `bin/mysql.cmd` (OSX) / `bin\mysql.cmd` (Win)<br />
    Das mysql Konsolen Kommando.

* `bin/mysqlconsole.cmd` (OSX) / `bin\mysqlconsole.cmd` (Win)<br />
    Das mysqldump Konsolen Kommando.

* `bin/mysqldump.cmd` (OSX) / `bin\mysqldump.cmd` (Win)<br />
    Das mysqldump Konsolen Kommando.

* `bin/php.cmd` (OSX) / `bin\php.cmd` (Win)<br />
    Das PHP Konsolen Kommando.

* `bin/showlogs.cmd` (OSX) / `bin\showlogs.cmd` (Win)<br />
    Anzeigen von Logausgaben der Dienste. Ohne Parameter werden alle Dienst angezeigt. Man kann den Dienstnamen als Parameter übergeben und bekommt dann nur dies Logausgaben angezeigt.<br />
    <br />
    Folgende Dienste sind möglich: db, phpmyadmin, mail, php, java

* `bin/update-crontab.cmd` (OSX) / `bin\update-crontab.cmd` (Win)<br />
    Wenn das crontab-File geändert wurde, dann können die Änderungen mit diesem Kommand aktiviert werden

* `bin/rebuild-java.cmd` (OSX) / `bin\rebuild-java.cmd` (Win)<br />
    Das rebuilden des java-Services kann mit diesem Kommando gestartet werden.

### Cronjobs
Im Verzeichnis `docker-data/volumes/php/cron/crontab` liegt die crontab in der Cronjobs eingerichtet werden können.
