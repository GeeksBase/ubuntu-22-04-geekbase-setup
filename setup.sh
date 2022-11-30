## Farben definieren
NC="\033[0m"
GREEN="\033[32m"
BLUE="\033[34m"
RED="\033[31m"

## Willkommens-Nachricht
echo -e "${BLUE}"
echo -e "---------------------------------------------"
echo -e "Willkommen zur Installation des GeeksBase"
echo -e "Ubuntu 22.04 Setup"
echo -e "---------------------------------------------"
echo -e "Dies ist ein Template für Hetzner Cloud Server"
echo -e "um Ubuntu 22.04 Server nach der Einrichtung den"
echo -e "Server etwas aufzuräumen, eine Grundabsicherung"
echo -e "zu schaffen und eine übersichtlichere Prompt zu haben."
echo -e "---------------------------------------------"
echo -e "${NC}"

# -------------------------------------------------------------------------------------------
echo "Aktualisiere Paketquellen & Pakete..."
# Update der Paketquellen und Pakete
apt-get update &>/dev/null && apt-get upgrade -y &> /dev/null

echo "Installiere benötigte Pakete..."
# Dependencies installieren
apt-get install whois -y &> /dev/null

# -------------------------------------------------------------------------------------------
echo "Deaktiviere Snap Services, falls vorhanden..."
# Deaktivieren von Snap Services, falls Sie existieren
find /etc/systemd/system -maxdepth 2 -name 'snap*' -exec basename -z {} \; \
| sort -uz | xargs -r0 systemctl disable &> /dev/null

# -------------------------------------------------------------------------------------------
echo "Entferne Ubuntu Advantage Tools, falls vorhanden..."
# Ubuntu Advantage Tools entfernen, falls vorhanden

apt-get purge --autoremove ubuntu-advantage-tools -y &> /dev/null

# -------------------------------------------------------------------------------------------
echo "Entferne Snap Pakete, falls vorhanden..."
# Deinstallieren von Snap Paketen, falls Sie existieren
for deb in $(dpkg -l | egrep "^ii" | awk ' {print $2} ' | sort | grep snap | sed -z 's/\n/ /g')
do
apt-get purge -y $deb &>/dev/null
done
apt-get autoremove -y &>/dev/null

# -------------------------------------------------------------------------------------------
echo "Entferne Snap und Games aus PATH..."
# Snap und Games aus PATH entfernen
sed -i "s/\:\/snap\/bin//g" /etc/environment | \
sed -i "s/\:\/usr\/local\/games//g" /etc/environment | \
sed -i "s/\:\/usr\/games//g" /etc/environment

# -------------------------------------------------------------------------------------------
echo "Konfiguriere die bashrc..."
# Diese bashrc Konfigurationsorte mit einer vernünftigen Konfiguration versorgen
# /etc/skel/.bashrc
# /etc/bash.bashrc
# /root/.bashrc

cat <<'EOF' > /etc/skel/.bashrc
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PS1='$(rc=$?; if [ $rc != 0 ]; then echo "\[\033[01;31m\]RC="$rc" "; fi)\[\033[1;37m\]\[\033[01;36m\]\t\[\033[1;37m\]\[\033[01;34m\] \h\[\033[1;37m\] \[\033[01;33m\]\w\[\033[1;37m\] \[\033[01;0m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF

# -------------------------------------------------------------------------------------------

cat <<'EOF' > /etc/bash.bashrc
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PS1='$(rc=$?; if [ $rc != 0 ]; then echo "\[\033[01;31m\]RC="$rc" "; fi)\[\033[1;37m\]\[\033[01;36m\]\t\[\033[1;37m\]\[\033[01;34m\] \h\[\033[1;37m\] \[\033[01;33m\]\w\[\033[1;37m\] \[\033[01;0m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF

# -------------------------------------------------------------------------------------------

cat <<'EOF' > /root/.bashrc
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PS1='$(rc=$?; if [ $rc != 0 ]; then echo "\[\033[01;31m\]RC="$rc" "; fi)\[\033[1;37m\]\[\033[01;36m\]\t\[\033[1;37m\]\[\033[01;34m\] \h\[\033[1;37m\] \[\033[01;33m\]\w\[\033[1;37m\] \[\033[01;0m\]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
EOF

# -------------------------------------------------------------------------------------------
echo "Konfiguriere bash_profile..."
# Diese bash_profile Konfigurationsorte mit einer vernünftigen Konfiguration versorgen
# /etc/skel/.bash_profile
# /etc/profile
# /root/.bash_profile

cat <<'EOF' >> /etc/skel/.bash_profile
source /etc/skel/.bashrc
EOF

cat <<'EOF' >> /etc/profile
source /etc/bash.bashrc
EOF

cat <<'EOF' >> /root/.bash_profile
source /root/.bashrc
EOF

# -------------------------------------------------------------------------------------------
echo "Erstelle SSH Benutzer..."
# sudo-Benutzer erstellen

read -p "Bitte gib einen SSH Benutzernamen an: " "sudo_user"
read -s -p "Bitte gib ein Passwort an: " "user_password"
echo ""

crypted_password=$(mkpasswd --method=SHA-512 --stdin $user_password)

useradd -m -p "${crypted_password}" -G "sudo" -s "/bin/bash" $sudo_user &> /dev/null

# -------------------------------------------------------------------------------------------
echo ""
echo "Installiere SSH Server, erstelle Konfiguration & starte SSH Server neu..."
# OpenSSH installieren, Konfiguration erstellen und SSH neustarten

apt install openssh-server &> /dev/null

cat <<EOF > /etc/ssh/sshd_config
Protocol 2

PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

PasswordAuthentication no
PermitEmptyPasswords no

PermitRootLogin no
AllowUsers $sudo_user
MaxAuthTries 3

X11Forwarding no

Include /etc/ssh/sshd_config.d/*.conf
EOF

# -------------------------------------------------------------------------------------------
echo "Konfiguration & Einrichtung des SSH Keys..."
# SSH Key entgegen nehmen oder generieren und alle wichtigen SSH Verzeichnisse Berechtigungen geben und Public Key hinzufügen zu autorisierten Keys

mkdir -p /etc/skel/.ssh
mkdir -p /home/$sudo_user/.ssh

unset confirm
until grep -qiE "^(y|n|yes|no)$"<<<$confirm; do read -p "Besitzt du bereits ein SSH Key, den du verwenden möchtest? (Y/N): " confirm; done
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
then
    read -p "Bitte gib deinen Public Key ein (Bsp.: ssh-ed25519 pndsa comment): " public_key
    echo $public_key > /etc/skel/.ssh/authorized_keys
    echo $public_key > /root/.ssh/authorized_keys
    echo $public_key > /home/$sudo_user/.ssh/authorized_keys
elif [[ $confirm == [nN] || $confirm == [nN][oO] ]]
then
    key_passphrase=$(read -p "Bitte gib eine Passphrase für deinen SSH Private Key ein: ")
    ssh_key=$(ssh-keygen -t ed25519 -N $key_passphrase -f /root/.ssh/id_ed25519)
    public_key=$(cat /root/.ssh/id_ed25519.pub)

    cp /root/.ssh/id_ed25519.pub /etc/skel/.ssh/authorized_keys
    cp /root/.ssh/id_ed25519.pub /root/.ssh/authorized_keys
    cp /root/.ssh/id_ed25519.pub /home/$sudo_user/.ssh/authorized_keys
else
    echo "Irgendwas läuft hier gewaltig schief...Wir brechen das Setup hier ab..."
fi

chown -R root:root /etc/skel
chown -R $sudo_user:$sudo_user /home/$sudo_user

chmod 700 /etc/skel/.ssh
chmod 600 /etc/skel/.ssh/authorized_keys

chmod 700 /home/$sudo_user/.ssh
chmod 600 /home/$sudo_user/.ssh/authorized_keys

# -------------------------------------------------------------------------------------------
echo "Starte SSH Server nach umfassender Konfiguration neu..."
# Neustarten des SSH Servers

systemctl restart sshd -y &> /dev/null

# -------------------------------------------------------------------------------------------
echo "Installiere und konfiguriere automatische Sicherheitsupdates..."
echo "Installiere und konfiguriere automatische Neustarts bei Updates, die ein Neustart erfordern..."
# Installation und Konfiguration von Unattended Upgrades und apt-config-auto-update

apt install unattended-upgrades -y &> /dev/null
apt install apt-config-auto-update -y &> /dev/null

systemctl enable unattended-upgrades -y &> /dev/null
systemctl stop unattended-upgrades -y &> /dev/null

read -p "Bitte gib eine E-Mail Adresse für technische Benachrichtigungen an: " "user_email"

sed -i "s/Unattended-Upgrade\:\:Mail .*/Unattended-Upgrade\:\:Mail \"${user_email}\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/Unattended-Upgrade\:\:MailReport.*/Unattended-Upgrade\:\:MailReport \"only-on-error\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/Unattended-Upgrade\:\:Remove-New-Unused-Dependencies.*/Unattended-Upgrade\:\:Remove-New-Unused-Dependencies \"true\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/Unattended-Upgrade\:\:Automatic-Reboot.*/Unattended-Upgrade\:\:Automatic-Reboot \"true\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/Unattended-Upgrade\:\:Automatic-Reboot-WithUsers.*/Unattended-Upgrade\:\:Automatic-Reboot-WithUsers \"false\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/Unattended-Upgrade\:\:Automatic-Reboot-Time.*/Unattended-Upgrade\:\:Automatic-Reboot-Time \"04:00\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s/Unattended-Upgrade\:\:SyslogEnable.*/Unattended-Upgrade\:\:SyslogEnable \"true\"\;/g" /etc/apt/apt.conf.d/50unattended-upgrades

systemctl start unattended-upgrades -y &> /dev/null

# -------------------------------------------------------------------------------------------
echo "Konfiguriere Log Rotation..."
# Log Rotate konfigurieren

apt install logrotate -y &> /dev/null

sleep 1

cat <<'EOF' > /etc/logrotate.d/alternatives
/var/log/alternatives.log {
        daily
        rotate 14
        compress
        delaycompress
        missingok
        notifempty
        create 644 root root
                dateext
                dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/apport
/var/log/apport.log {
       daily
       rotate 14
       delaycompress
       compress
       notifempty
       missingok
           dateext
           dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/apt
/var/log/apt/term.log {
  rotate 14
  daily
  compress
  missingok
  notifempty
  dateext
  dateformat .%Y-%m-%d
}

/var/log/apt/history.log {
  rotate 14
  daily
  compress
  missingok
  notifempty
  dateext
  dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/bootlog
/var/log/boot.log
{
    missingok
    daily
    copytruncate
    rotate 14
    notifempty
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/btmp
# no packages own btmp -- we'll rotate it here
/var/log/btmp {
    missingok
    daily
    create 0660 root utmp
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/dpkg
/var/log/dpkg.log {
        daily
        rotate 14
        compress
        delaycompress
        missingok
        notifempty
        create 644 root root
                dateext
                dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/rsyslog
/var/log/syslog
/var/log/mail.info
/var/log/mail.warn
/var/log/mail.err
/var/log/mail.log
/var/log/daemon.log
/var/log/kern.log
/var/log/auth.log
/var/log/user.log
/var/log/lpr.log
/var/log/cron.log
/var/log/debug
/var/log/messages
{
        rotate 14
        daily
        missingok
        notifempty
        compress
        delaycompress
        sharedscripts
        postrotate
                /usr/lib/rsyslog/rsyslog-rotate
        endscript
                dateext
                dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/ufw
/var/log/ufw.log
{
        rotate 14
        daily
        missingok
        notifempty
        compress
        delaycompress
        sharedscripts
        postrotate
                [ -x /usr/lib/rsyslog/rsyslog-rotate ] && /usr/lib/rsyslog/rsyslog-rotate || true
        endscript
                dateext
            dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/unattended-upgrades
/var/log/unattended-upgrades/unattended-upgrades.log
/var/log/unattended-upgrades/unattended-upgrades-dpkg.log
/var/log/unattended-upgrades/unattended-upgrades-shutdown.log
{
  rotate 14
  daily
  compress
  missingok
  notifempty
  dateext
  dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/wtmp
# no packages own wtmp -- we'll rotate it here
/var/log/wtmp {
    missingok
    daily
    create 0664 root utmp
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/do-release-upgrade
/var/log/dist-upgrade/*.log
/var/log/dist-upgrade/*.txt
 {
    missingok
    daily
    create 0664 root root
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/landscape
/var/log/landscape/*.log
 {
    missingok
    daily
    create 0664 landscape landscape
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/private
/var/log/private/*.log
 {
    missingok
    daily
    create 0664 root root
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/cloud-init
/var/log/cloud-init.log
 {
    missingok
    daily
    create 0664 syslog adm
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/cloud-init
/var/log/cloud-init-output.log
 {
    missingok
    daily
    create 0664 root adm
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/dmesg
/var/log/dmesg
 {
    missingok
    daily
    create 0640 root adm
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

systemctl restart logrotate.service &>/dev/null

# -------------------------------------------------------------------------------------------
echo "Installiere Fail2Ban und konfiguriere SSH Jail"
# Fail2Ban Grundinstallation mit SSH Jail

apt-get install fail2ban -y &>/dev/null
systemctl enable fail2ban &>/dev/null
systemctl stop fail2ban &>/dev/null


cat <<'EOF' > /etc/fail2ban/fail2ban.d/loglevel.conf
loglevel = ERROR
EOF

sleep 1

cat <<'EOF' > /etc/fail2ban/jail.d/ssh.conf.local
[sshd]
 enabled = true
 port = ssh
 filter = sshd
 logpath = /var/log/auth.log
 maxretry = 3
 bantime  = 3600
 findtime  = 300
 ignoreip = 127.0.0.1
EOF

sleep 1

cat <<'EOF' > /etc/logrotate.d/fail2ban
/var/log/fail2ban.log
 {
    missingok
    daily
    create 0640 root adm
    minsize 1M
    rotate 14
        dateext
        dateformat .%Y-%m-%d
}
EOF

sleep 1

systemctl restart logrotate.service &>/dev/null
systemctl start fail2ban &>/dev/null

echo -e ""
echo -e ""
echo -e "#############################################################################"
echo -e ""
echo -e "${GREEN}#####################################################"
echo -e "## GeekBase Ubuntu 22.04 Setup abgeschlossen       ##"
echo -e "#####################################################${NC}"
echo -e ""
echo -e "Vielen Dank für die Nutzung des GeekBase Ubuntu 22.04 Setups."
echo -e ""
echo -e "${BLUE}######################################################"
echo -e "## E-Mail für technische Benachrichtigungen         ##"
echo -e "######################################################${NC}"
echo -e ""
echo -e "${user_email}"
echo -e ""
echo -e ""
echo -e "${BLUE}######################################################"
echo -e "## Erstellter SSH Benutzer zur SSH Verbindung       ##"
echo -e "######################################################${NC}"
echo -e ""
echo -e "${sudo_user}"
echo -e ""
echo -e ""
echo -e "${BLUE}######################################################"
echo -e "## Öffentlicher Schlüssel, platziert auf Server     ##"
echo -e "######################################################${NC}"
echo -e ""
if [[ -f /root/.ssh/id_ed25519.pub ]]
then
    echo -e "${public_key}"
    echo -e ""
    echo -e "Dieser Public-Key wurde bereits konfiguriert."
else
    echo -e "Es wurde kein Public Key generiert, da du einen eigenen Public Key mitgebracht hast."
fi
echo -e ""
echo -e ""
echo -e "${BLUE}######################################################"
echo -e "## Privater Schlüssel, auf Client platzieren        ##"
echo -e "######################################################${NC}"
echo -e ""
if [[ -f /root/.ssh/id_ed25519 ]]
then
    echo -e "Du benötigst diesen Private Key nun um dich per SSH auf den Server verbinden zu können."
    echo -e ""
    echo -e "${private_key}"
else
    echo -e "Es wurde kein Private Key generiert, da du einen eigenen Public Key mitgebracht hast."
fi
echo -e ""
echo -e ""