# Ubuntu 22.04 - Geekbase Setup

Hierbei handelt es sich um ein Setup-Script, vollständig in Bash geschrieben - welches einem Ubuntu 22.04 Server (optimalerweise bei Hetzner) eine "kleine Grundinstallation nach der Installation" verpasst.

## Was ist enthalten?

- Update der Paketquellen und Pakete
- Deaktivieren von Snap Services, falls Sie existieren
- Ubuntu Advantage Tools entfernen, falls Sie existieren
- Entfernen von Snap Paketen, falls Sie existrieren
- Snap und Games aus PATH entfernen
- Die bashrc & bash_profile global und im User Skelett optimiert
- Erstellen eines sudo-Benutzers mit eigenem Passwort
- Optimierung des openSSH Servers
 - Enthält Zugriff per Pubkey nur vom erstellten SSH sudo-Benutzer
 - Optional kann man einen eigenen Public Key angeben, falls vorhanden
 - ansonsten wird ein ED25519 SSH Key generiert (inkl. Passphrase)
 - Verteilen des SSH Keys auf den root, sudo-Benutzer & User-Skelett
- Konfiguration von automatischen E-Mail Benachrichtigungen
- DSGVO konforme Log Rotation (täglich neu, Rotation 14 Tage, komprimiert)
- Fail2Ban inklusive SSH Jail (SSH Brute Force Erkennung)

## Wie funktioniert es?

 - Erstelle einen Ubuntu 22.04 Server inkl. FQHN
 - Logge dich als root-Benutzer per SSH auf den Server
 - `cd /root`
 - `wget https://raw.githubusercontent.com/GeeksBase/ubuntu-22-04-geekbase-setup/main/setup.sh`
 - `chmod u+x setup.sh && ./setup.sh`
 
 Du wirst dann während der Durchführung nach verschiedenem Input aufgefordert. Fülle dies einfach wie beschrieben aus.
 
 Am Ende werden dir die wichtigsten Informationen nochmal angezeigt.
 
## Contribution

Nur Pull Requests. Ist semi-aktiv in der Entwicklung.
