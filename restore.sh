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

crear_directorio_si_no_existe() {
    if test -d $1; then
        echo "el directorio $1 ya existe"
    else
        echo "el directorio $1 no existe"
        echo "creando el directorio $1"
        mkdir -p $1
    fi
}

sustituir_revisando_origen_y_destino() {
    ruta_origen=$1
    ruta_destino=$2
    crear_directorio_si_no_existe $ruta_destino
    if test -f $ruta_origen; then
        echo "la ruta $ruta_origen es de un archivo"
        echo "copiando el archivo de la ruta $ruta_origen a la ruta $ruta_destino"
        cp -r -f $ruta_origen $ruta_destino
    elif test -d $ruta_origen; then
        echo "la ruta $ruta_origen es de un directorio"
        echo "copiando el contenido de la ruta $ruta_origen a la ruta $ruta_destino"
        cp -r -f $ruta_origen/* $ruta_destino
    else
        echo "la ruta de origen $ruta_origen no existe"
    fi
}

echo -e "iniciando restauración de configuraciones personalizadas"

echo -e
echo -e "restaurando configuraciones de indicador del sistema"
ruta_backup_widgets=$backups_path/widgets/.indicator-sysmonitor.json
ruta_origen_widgets=$home
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
sudo find $ruta_origen_snap -type f -exec chmod 777 {} \;
sleep 2
sustituir_revisando_origen_y_destino $ruta_backup_snap $ruta_origen_snap
sleep 2
sudo find $ruta_origen_snap -type f -exec chmod 755 {} \;

echo -e
echo -e "restaurando configuraciones de zsh y p10k"
ruta_backup_zsh_1=$backups_path/zsh/.p10k.zsh
ruta_backup_zsh_2=$backups_path/zsh/.zshrc
rute_origen_zsh=$home
sustituir_revisando_origen_y_destino $ruta_backup_zsh_1 $rute_origen_zsh
sustituir_revisando_origen_y_destino $ruta_backup_zsh_2 $rute_origen_zsh

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
