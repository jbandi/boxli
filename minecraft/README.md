# Minecraft auf Boxli

Dieses Projekt betreibt einen Minecraft-Server und seine Begleitdienste mit Docker Compose auf dem Raspberry Pi. Es wird **nicht lokal auf dem Mac** gestartet.

## Aktueller Betriebszustand

Am 11. Oktober 2026 wurde das gesamte Compose-Projekt mit `docker compose stop --timeout 120` gestoppt. Die Container, Images, Welten, Backups und persistenten Monitoring-Daten bleiben erhalten. Die Compose-Konfiguration und die `.env` wurden nicht geändert.

Alle 13 Dienste verwenden `restart: unless-stopped`. Deshalb bleiben sie nach diesem ausdrücklichen Stopp auch bei einem Neustart des Raspberry oder von Docker ausgeschaltet. Sobald sie wieder gestartet werden, starten sie auch bei folgenden Systemneustarts wieder automatisch, bis sie erneut ausdrücklich gestoppt werden.

Docker selbst bleibt aktiviert. VNC, Desktop, SSH, InfluxDB und die Pironman-Gehäusesoftware gehören nicht zu diesem Compose-Projekt und wurden nicht gestoppt.

### Prüfung nach der Stilllegung

Alle 13 Container wurden als `Exited` bestätigt. Der Minecraft-Server hat laut Abschlussprotokoll Spieler und alle Dimensionen gespeichert und sich mit Exit-Code 0 beendet. Die Hilfsdienste `dyndns`, `file-metrics` und `lametric-writer` wurden nach Ablauf der 120 Sekunden von Docker beendet (Exit-Code 137, kein Speichermangel). Die Compose-Konfiguration wurde erfolgreich mit `docker compose config --quiet` validiert.

Der verfügbare Arbeitsspeicher stieg unmittelbar danach von rund 5,7 GiB auf rund 14 GiB; diese Werte sind Momentaufnahmen.

## Mit dem Raspberry verbinden

Vom Mac aus direkt mit dem Projektbenutzer verbinden:

```bash
ssh mc@192.168.1.13
cd /home/mc/minecraft
```

Auf dem eingerichteten Mac funktioniert alternativ `ssh boxli`; dieses SSH-Kürzel verwendet den Benutzer `mc`. Die IP-Adresse gilt zum Zeitpunkt der Stilllegung und muss bei einer späteren Adressänderung angepasst werden.

**Alle folgenden Docker-Befehle auf dem Raspberry im Verzeichnis `/home/mc/minecraft` ausführen.** Der Benutzer `mc` hat bereits Docker-Zugriff; dafür ist kein `sudo` erforderlich.

## Status prüfen

```bash
docker compose ps -a
```

`Exited` bedeutet gestoppt, `Up` bedeutet laufend. Nur laufende Dienste anzeigen:

```bash
docker compose ps --status running
```

## Das gesamte Projekt wieder starten

Solange die vorhandenen Container nicht entfernt wurden:

```bash
docker compose start
```

Damit werden alle vorhandenen Projektcontainer mit ihren bisherigen Images und Einstellungen gestartet. Es werden keine neuen Images heruntergeladen.

Danach prüfen:

```bash
docker compose ps -a
docker compose logs --tail=100 mc
```

Der Minecraft-Server benötigt Zeit zum Hochfahren. Bei Problemen die betreffenden Dienst-Logs prüfen, beispielsweise `docker compose logs --tail=100 grafana`.

Falls Container inzwischen entfernt wurden oder Änderungen an der Compose-Konfiguration angewendet werden sollen:

```bash
docker compose up -d
```

Dieser Befehl kann Container neu erstellen und fehlende Images herunterladen. Vorher sicherstellen, dass die bisherigen Datenverzeichnisse und Docker-Volumes vorhanden sind. Die vorhandene `.env` auf dem Raspberry beibehalten; sie enthält die erforderlichen Einstellungen und Zugangsdaten.

## Wieder geordnet stoppen

```bash
docker compose stop --timeout 120
docker compose ps -a
```

Das gibt den Diensten bis zu 120 Sekunden zum Beenden. Anschließend bleiben sie mit der bestehenden Neustartregel auch nach einem Reboot gestoppt. Keine Lösch- oder Bereinigungsbefehle wie `docker compose down -v` oder `docker system prune --volumes` zum bloßen Stilllegen verwenden: Sie können persistente Daten entfernen.

## Enthaltene Dienste

| Compose-Dienst | Aufgabe |
| --- | --- |
| `mc` | Minecraft-Server; Containername `minecraft` |
| `backup` | Minecraft-Backups |
| `dyndns` | Dynamische DNS-Aktualisierung |
| `prometheus` | Metrikspeicherung |
| `grafana` | Monitoring-Dashboards |
| `loki` | Logspeicherung |
| `alloy` | Sammlung und Weiterleitung von Monitoring-Daten |
| `node-exporter` | Systemmetriken |
| `cadvisor` | Containermetriken |
| `blackbox-exporter` | Erreichbarkeitsprüfungen |
| `file-metrics` | Aufbereitung dateibasierter Metriken |
| `lametric-writer` | Aufbereitung der LaMetric-Anzeige |
| `boxli-http` | HTTP-Bereitstellung von Projektinhalten |

## Konfiguration und Deployment

- Lokales Projekt: `/Users/jonas/Dev/boxli/minecraft`
- Laufendes Deployment auf dem Raspberry: `/home/mc/minecraft`
- Quelle der Dienstkonfiguration: `docker-compose.yml`
- Neustartregel: `restart: unless-stopped` für sämtliche Dienste

Für einen einfachen Wiederanlauf `docker compose start` verwenden. `dev/deploy.sh --apply` ist ein Deployment mit Dateisynchronisation, Image-Downloads und Neuerstellung ausgewählter Container; es ist kein bloßer Startbefehl. Ohne `--restart-mc` lässt dieses Skript die Dienste `mc` und `backup` aus.

Dokumentation zur Neustartregel: https://docs.docker.com/engine/containers/start-containers-automatically/
