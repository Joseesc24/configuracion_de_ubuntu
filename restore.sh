#!/bin/bash
set -e

echo -e
sudo -k

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
backups_path=$scripts_path/backups
home=$HOME

sudo -v
echo -e

echo -e "Iniciando restauración de configuraciones personalizadas"
echo -e

echo -e "Restaurando configuraciones de indicador del sistema"
sudo cp -f $backups_path/widgets/.indicator-sysmonitor.json $home/

echo -e "Restaurando configuraciones de fuentes personalizadas"
if test -d $home/.fonts; then
    echo "El directorio de fuentes ya existe, no hace falta hacer más cambios"
else
    echo "El directorio de fuentes no existe, creando directorio de fuentes"
    mkdir $home/.fonts
    echo "Directorio de fuentes creado"
fi
unzip -oq $home$backups_path/custom_fonts.zip -d $home/.fonts

echo -e "Restaurando configuraciones de terminal"
dconf load /org/gnome/terminal/legacy/profiles:/ <$home$backups_path/terminals/gnome-terminal.dconf

echo -e "Restaurando configuraciones de tilix"
dconf load /com/gexperts/Tilix/ <$home$backups_path/terminals/tilix.dconf
sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper

echo -e "Restaurando configuraciones de snap"
sudo find $home$backups_path/snap_configs/ -type f -exec chmod 777 {} \;
sudo cp -r $home$backups_path/snap_configs/* /var/lib/snapd/desktop/applications

echo -e "Restaurando configuraciones de zsh y p10k"
sudo cp $home$backups_path/terminals/.p10k.zsh $home
sudo cp $home$backups_path/terminals/.zshrc $home
sudo usermod --shell $(which zsh) $user >/dev/null

echo -e "Restaurando configuraciones de numix"
gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'

echo -e "Restaurando configuraciones de docker-engine"
if grep -q docker /etc/group; then
    echo "El grupo docker ya existe, no hace falta hacer más cambios"
else
    echo "El grupo docker no existe, creando grupo docker"
    sudo addgroup --system docker
    echo "Grupo docker creado"
fi
if getent group docker | grep -q "\b$user\b"; then
    echo "El usuario $user ya pertenece al grupo docker, no hace falta hacer más cambios"
else
    echo "El usuario $user no pertenece aún al grupo docker, agregando $user al grupo docker"
    sudo adduser $user docker
    echo "Usuario $user agregado $user al grupo docker"
fi

echo -e "Respaldando configuraciones de vlc"
sudo cp $home$backups_path/vlc/eDark\ Vlc.vlt $home/snap/vlc/

echo -e
echo -e "Restauraciones de configuraciones personalizadas finalizadas"
echo -e
