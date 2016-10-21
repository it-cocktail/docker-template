# Anleitung

## Installation

* Das aktulle Release unter Tags herunterladen (**nicht auschecken**)
* Die Datei .env-dist nach .env kopieren und anpassen (**mindestens die `BASE_DOMAIN`**)

Folgende Einstellungsmöglichkeiten gibt es:

* `PROXY_PORT`<br />
    Der Port für den Proxy unter dem Web-Container erreichbar sind

* `UI_PORT`<br />
    Der Port für die Docker-UI Managing Applikation.<br />
    Erreichbar unter ht<span>tp://</span>localhost:[UI_PORT]

* `PHP_VERSION`<br />
    Die PHP-Version des Web-Containers. (5.5, 5.6, 7.0 und 7.1 sind möglich)

* `MYSQL_VERSION`<br />
    Die MySQL-Version der Datenbank-Containers. (5.5 und 5.7 sind möglich)

* `MYSQL_ROOT_PASSWORD`<br />
    Das MySQL Root Password.

* `BASE_DOMAIN`<br />
    Die Basis-Domain für diese Application.<br />
    Im DNS ist gehen alle Einträge unterhalb von *.local.orangehive.de auf localhost und können automatisch ohne Hosts-Eintrag genutzt werden.
    Es gibt folgende Hosts:
    
    - w<span>ww</span>.[BASE_DOMAIN]
    - phpmyadmin.[BASE_DOMAIN]
    - mailhog.[BASE_DOMAIN]

* `HTDOCS_FOLDER`<br />
    Der htdocs Folder in den die PHP-Sourcen liegen.

* `DOCUMENT_ROOT`<br />
    Der Apache Document-Root relativ zum `HTDOCS_FOLDER`. (z.B. `web` für typo3 oder `public` für zend)

## Betrieb

Alle Kommandos befinden sich im Verzeichnis `bin` und müssen aus dem Hauptverzeichnis aus aufgerufen werden.

Folgende Kommandos gibt es:

* `bin/start.cmd` (OSX) / `bin\start.cmd` (Win)<br />
    Zum starten der Services. Mit dem Parameter `-d` wird die XDebug Extension aktiviert.
 
* `bin/stop.cmd` (OSX) / `bin\start.cmd` (Win)<br />
    Zum Beenden der Services.
  
* `bin/compass.cmd` (OSX) / `bin\compass.cmd` (Win)<br />
    Das Compass Konsolen Kommando.

* `bin/composer.cmd` (OSX) / `bin\composer.cmd` (Win)<br />
    Das Composer Konsolen Kommando. Es wird mit der eingestellten PHP Version ausgeführt.

* `bin/console.cmd` (OSX) / `bin\console.cmd` (Win)<br />
    Mit diesem Kommando kommt man in die Bash des PHP Containers.

* `bin/mysql.cmd` (OSX) / `bin\mysql.cmd` (Win)<br />
    Das mysql Konsolen Kommando.

* `bin/mysqldump.cmd` (OSX) / `bin\mysqldump.cmd` (Win)<br />
    Das mysqldump Konsolen Kommando.

* `bin/php.cmd` (OSX) / `bin\php.cmd` (Win)<br />
    Das PHP Konsolen Kommando.

