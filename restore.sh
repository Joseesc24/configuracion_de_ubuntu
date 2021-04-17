#!/bin/bash
set -e

echo -e
sudo -k

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
backups_path=$scripts_path/backups
home=$HOME
user=$USER

sudo -v
echo -e

sustituir_revisando_origen_y_destino() {
    ruta_origen=$1
    ruta_destino=$2
    if test -f $ruta_origen; then
        echo "la ruta $ruta_origen es de un archivo"
    elif test -d $ruta_origen; then
        echo "la ruta $ruta_origen es de un directorio"
    else
        echo "la ruta de origen $ruta_origen no existe"
    fi
}

echo -e "iniciando restauración de configuraciones personalizadas"

echo -e
echo -e "restaurando configuraciones de indicador del sistema"
ruta_backup_widgets=$backups_path/widgets
ruta_origen_widgets=$home/.indicator-sysmonitor.json
sustituir_revisando_origen_y_destino $ruta_backup_widgets $ruta_origen_widgets

echo -e
echo -e "restaurando configuraciones de fuentes personalizadas"
ruta_backup_fuentes=$backups_path/fuentes
ruta_origen_fuentes=$home/.fonts
sustituir_revisando_origen_y_destino $ruta_backup_fuentes $ruta_origen_fuentes

echo -e
echo -e "restaurando configuraciones de terminal"
ruta_terminal=$backups_path/terminal
archivo_terminal=$ruta_terminal/gnome-terminal.dconf
dconf load /org/gnome/terminal/legacy/profiles:/ <$archivo_terminal

echo -e
echo -e "restaurando configuraciones de tilix"
ruta_tilix=$backups_path/tilix
archivo_tilix=$ruta_tilix/tilix.dconf
dconf load /com/gexperts/Tilix/ <$archivo_tilix
sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper

echo -e
echo -e "restaurando configuraciones de snap"
ruta_backup_snap=$backups_path/snap
ruta_origen_snap=/var/lib/snapd/desktop/applications/
sustituir_revisando_origen_y_destino $ruta_backup_snap $ruta_origen_snap
sudo find $ruta_origen_snap -type f -exec chmod 755 {} \;

echo -e
echo -e "restaurando configuraciones de zsh y p10k"
ruta_backup_zsh=$backups_path/zsh
rute_origen_zsh_1=$home/.p10k.zsh
rute_origen_zsh_2=$home/.zshrc
sustituir_revisando_origen_y_destino $ruta_backup_zsh $rute_origen_zsh_1
sustituir_revisando_origen_y_destino $ruta_backup_zsh $rute_origen_zsh_2

echo -e
echo -e "restaurando configuraciones de vlc"
ruta_backup_vlc=$backups_path/vlc
ruta_origen_vlc=$home/snap/vlc/eDark_Vlc.vlt
sustituir_revisando_origen_y_destino $ruta_backup_vlc $ruta_origen_vlc

echo -e
echo -e "restaurando configuraciones de numix"
gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'

echo -e
echo -e "restaurando configuraciones de docker-engine"
if grep -q docker /etc/group; then
    echo "el grupo docker ya existe, no hace falta hacer más cambios"
else
    echo "el grupo docker no existe, creando grupo docker"
    sudo addgroup --system docker
fi
if getent group docker | grep -q "\b$user\b"; then
    echo "el usuario $user ya pertenece al grupo docker, no hace falta hacer más cambios"
else
    echo "el usuario $user no pertenece aún al grupo docker, agregando $user al grupo docker"
    sudo adduser $user docker
fi

echo -e
echo -e "restauraciones de configuraciones personalizadas finalizadas"
echo -e
