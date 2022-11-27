# Ubuntu 22.04 - Geekbase Setup

Hierbei handelt es sich um ein Setup-Script, vollständig in Bash geschrieben - welches einem Ubuntu 22.04 Server (optimalerweise bei Hetzner) eine "kleine Grundinstallation nach der Installation" verpasst.

## Was ist enthalten?

- Update der Paketquellen und Pakete
- Deaktivieren von Snap Services, falls Sie existieren
- Ubuntu Advantage Tools entfernen
- Entfernen von Snap Paketen, falls Sie existrieren
- Snap und Games aus PATH entfernen
- Die bashrc & bash_profile global und im User Skelett optimiert
- Erstellen eines sudo-Benutzers
- Eine abgehärterte SSH Konfiguration angelegt
 - Enthält Zugriff per Pubkey nur vom erstellten SSH sudo-Benutzer
- Einen ED25519 SSH Key generieren, Passphrase wird abgefragt
- Verteilen des SSH Keys auf den root, sudo-Benutzer & User-Skelett
- Konfiguration von automatischen E-Mail Benachrichtigungen (funktioniert nur in Kombination mit Mail Gateway/Relay Installation)
- DSGVO konforme Log Rotation (täglich neu, rotation 14 Tage, komprimiert)
- Fail2Ban inklusive SSH Jail (SSH Brute Force Erkennung)

## Wie funktioniert es?

 - Erstelle einen Ubuntu 22.04 Server inkl. FQHN
 - Logge dich als root-Benutzer per SSH auf den Server
 - `cd /root`
 - `wget https://github.com/GeeksBase/ubuntu-22-04-geekbase-setup/archive/refs/heads/main.zip`
 - `unzip main.zip`
 - `chmod u+x setup.sh && bash setup.sh`
 
 Du wirst dann während der Durchführung nach verschiedenem Input aufgefordert. Fülle dies einfach wie beschrieben aus.
 
 Am Ende werden dir die wichtigsten Informationen nochmal angezeigt.
 
## Contribution

Nur Pull Requests. Ist semi-aktiv in der Entwicklung.
