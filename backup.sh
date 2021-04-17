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

crear_archivo_si_no_existe() {
    if test -f $1; then
        echo "el archivo $1 ya existe"
    else
        echo "el archivo $1 no existe"
        echo "creando el archivo $1"
        touch $1
    fi
}

copiar_revisando_origen_y_destino() {
    ruta_origen=$1
    ruta_destino=$2
    crear_directorio_si_no_existe $ruta_destino
    if test -f $ruta_origen; then
        echo "la ruta $ruta_origen es de un archivo"
        echo "copiando el archivo de la ruta $ruta_origen a la ruta $ruta_destino"
        cp -r $ruta_origen $ruta_destino
    elif test -d $ruta_origen; then
        echo "la ruta $ruta_origen es de un directorio"
        echo "copiando el contenido de la ruta $ruta_origen a la ruta $ruta_destino"
        cp -r $ruta_origen/* $ruta_destino
    else
        echo "la ruta de origen $ruta_origen no existe"
    fi
}

echo -e "iniciando respaldo de configuraciones personalizadas"

echo -e
echo -e "respaldando configuraciones de indicador del sistema"
ruta_backup_widgets=$backups_path/widgets
ruta_origen_widgets=$home/.indicator-sysmonitor.json
copiar_revisando_origen_y_destino $ruta_origen_widgets $ruta_backup_widgets

echo -e
echo -e "respaldando configuraciones de fuentes personalizadas"
ruta_backup_fuentes=$backups_path/fuentes
ruta_origen_fuentes=$home/.fonts
copiar_revisando_origen_y_destino $ruta_origen_fuentes $ruta_backup_fuentes

echo -e
echo -e "respaldando configuraciones de terminal"
ruta_terminal=$backups_path/terminal
crear_directorio_si_no_existe $ruta_terminal
archivo_terminal=$ruta_terminal/gnome-terminal.dconf
crear_archivo_si_no_existe $archivo_terminal
dconf dump /org/gnome/terminal/legacy/profiles:/ >$archivo_terminal

echo -e
echo -e "respaldando configuraciones de tilix"
ruta_tilix=$backups_path/tilix
crear_directorio_si_no_existe $ruta_tilix
archivo_tilix=$ruta_tilix/tilix.dconf
crear_archivo_si_no_existe $archivo_tilix
dconf dump /com/gexperts/Tilix/ >$archivo_tilix

echo -e
echo -e "respaldando configuraciones de snap"
ruta_backup_snap=$backups_path/snap
ruta_origen_snap=/var/lib/snapd/desktop/applications/
copiar_revisando_origen_y_destino $ruta_origen_snap $ruta_backup_snap
sleep 2
sudo find $ruta_backup_snap -type f -exec chmod 777 {} \;

echo -e
echo -e "respaldando configuraciones de zsh"
ruta_backup_zsh=$backups_path/zsh
rute_origen_zsh_1=$home/.p10k.zsh
rute_origen_zsh_2=$home/.zshrc
copiar_revisando_origen_y_destino $rute_origen_zsh_1 $ruta_backup_zsh
copiar_revisando_origen_y_destino $rute_origen_zsh_2 $ruta_backup_zsh

echo -e
echo -e "respaldando configuraciones de vlc"
ruta_backup_vlc=$backups_path/vlc
ruta_origen_vlc=$home/snap/vlc/eDark_Vlc.vlt
copiar_revisando_origen_y_destino $ruta_origen_vlc $ruta_backup_vlc

echo -e
echo -e "respaldo de configuraciones personalizadas finalizado"
echo -e
