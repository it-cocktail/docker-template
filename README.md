# Anleitung

## Installation

* Das aktulle Release unter Tags herunterladen (**nicht auschecken**)
* Die Datei .env-dist nach .env kopieren und anpassen (**mindestens die `BASE_DOMAIN`**)

Folgende Einstellungsm�glichkeiten gibt es:

* `PROXY_PORT`<br />
    Der Port f�r den Proxy unter dem Web-Container erreichbar sind

* `UI_PORT`<br />
    Der Port f�r die Docker-UI Managing Applikation.<br />
    Erreichbar unter http://localhost:<UI_PORT>

* `PHP_VERSION`<br />
    Die PHP-Version des Web-Containers. (5.5, 5.6, 7.0 und 7.1 sind m�glich)

* `MYSQL_VERSION`<br />
    Die MySQL-Version der Datenbank-Containers. (5.5 und 5.7 sind m�glich)

* `MYSQL_ROOT_PASSWORD`<br />
    Das MySQL Root Password.

* `BASE_DOMAIN`<br />
    Die Basis-Domain f�r diese Application.<br />
    Es gibt folgende Hosts:
    
    - www.<BASE_DOMAIN>
    - phpmyadmin.<BASE_DOMAIN>
    - mailhog.<BASE_DOMAIN>

* `HTDOCS_FOLDER`<br />
    Der htdocs Folder in den die PHP-Sourcen liegen.

* `DOCUMENT_ROOT`<br />
    Der Apache Document-Root relativ zum `HTDOCS_FOLDER`. (z.B. `web` f�r typo3 oder `public` f�r zend)

## Betrieb

Alle Kommandos befinden sich im Verzeichnis `bin` und m�ssen aus dem Hauptverzeichnis aus aufgerufen werden.

Folgende Kommandos gibt es:

* `bin/start.cmd` (OSX) / `bin\start.cmd` (Win)<br />
    Zum starten der Services. Mit dem Paramter `-d` wird die XDebug Extension aktiviert.
 
* `bin/stop.cmd` (OSX) / `bin\start.cmd` (Win)<br />
    Zum Beenden der Services.
  
* `bin/compass.cmd` (OSX) / `bin\compass.cmd` (Win)<br />
    Das Compass Konsolen Kommando.

* `bin/composer.cmd` (OSX) / `bin\composer.cmd` (Win)<br />
    Das Composer Konsolen Kommando. Es wird mit der eingestellten PHP Version ausgef�hrt.

* `bin/console.cmd` (OSX) / `bin\console.cmd` (Win)<br />
    Mit diesem Kommando kommt man in die Bash des PHP Containers.

* `bin/mysql.cmd` (OSX) / `bin\mysql.cmd` (Win)<br />
    Das mysql Konsolen Kommando.

* `bin/mysqldump.cmd` (OSX) / `bin\mysqldump.cmd` (Win)<br />
    Das mysqldump Konsolen Kommando.

* `bin/php.cmd` (OSX) / `bin\php.cmd` (Win)<br />
    Das PHP Konsolen Kommando.

