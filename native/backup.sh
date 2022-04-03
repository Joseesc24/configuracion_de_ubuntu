#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
backups_path=$scripts_path/backups
source $scripts_path/commons.sh

home=$HOME
user=$USER

remove_and_ask_password

crear_directorio_si_no_existe() {

    if test -d $1; then

        print_text "el directorio $1 ya existe"

    else

        print_text "el directorio $1 no existe"
        print_text "creando el directorio $1"

        mkdir -p $1

    fi

}

crear_archivo_si_no_existe() {

    if test -f $1; then

        print_text "el archivo $1 ya existe"

    else

        print_text "el archivo $1 no existe"
        print_text "creando el archivo $1"

        touch $1

    fi

}

copiar_revisando_origen_y_destino() {

    ruta_origen=$1
    ruta_destino=$2

    crear_directorio_si_no_existe $ruta_destino

    if test -f $ruta_origen; then

        print_text "la ruta $ruta_origen es de un archivo"
        print_text "copiando el archivo de la ruta $ruta_origen a la ruta $ruta_destino"

        cp -r $ruta_origen $ruta_destino

    elif test -d $ruta_origen; then

        print_text "la ruta $ruta_origen es de un directorio"
        print_text "copiando el contenido de la ruta $ruta_origen a la ruta $ruta_destino"

        cp -r $ruta_origen/* $ruta_destino

    else

        print_text "la ruta de origen $ruta_origen no existe"

    fi

}

print_title "Iniciando Respaldo De Configuraciones Personalizadas"

print_title "1/7 - Respaldando Configuraciones De Indicador Del Sistema"

ruta_backup_widgets=$backups_path/widgets
ruta_origen_widgets=$home/.indicator-sysmonitor.json
copiar_revisando_origen_y_destino $ruta_origen_widgets $ruta_backup_widgets

print_title "2/7 - Respaldando Configuraciones De Fuentes Personalizadas"

ruta_backup_fuentes=$backups_path/fuentes
ruta_origen_fuentes=$home/.fonts
copiar_revisando_origen_y_destino $ruta_origen_fuentes $ruta_backup_fuentes

print_title "3/7 - Respaldando Configuraciones De Terminal"

ruta_terminal=$backups_path/terminal
crear_directorio_si_no_existe $ruta_terminal
archivo_terminal=$ruta_terminal/gnome-terminal.dconf
crear_archivo_si_no_existe $archivo_terminal
dconf dump /org/gnome/terminal/legacy/profiles:/ >$archivo_terminal

print_title "4/7 - Respaldando Configuraciones De Tilix"

ruta_tilix=$backups_path/tilix
crear_directorio_si_no_existe $ruta_tilix
archivo_tilix=$ruta_tilix/tilix.dconf
crear_archivo_si_no_existe $archivo_tilix
dconf dump /com/gexperts/Tilix/ >$archivo_tilix

print_title "5/7 - Respaldando Configuraciones De Iconos De Snap"

ruta_backup_snap=$backups_path/snap
ruta_origen_snap=/var/lib/snapd/desktop/applications/
copiar_revisando_origen_y_destino $ruta_origen_snap $ruta_backup_snap
sleep 2
sudo find $ruta_backup_snap -type f -exec chmod 777 {} \;

print_title "6/7 - Respaldando Configuraciones De Zsh"

ruta_backup_zsh=$backups_path/zsh
rute_origen_zsh_1=$home/.p10k.zsh
rute_origen_zsh_2=$home/.zshrc
copiar_revisando_origen_y_destino $rute_origen_zsh_1 $ruta_backup_zsh
copiar_revisando_origen_y_destino $rute_origen_zsh_2 $ruta_backup_zsh

print_title "7/7 - Comprimiendo Resplado En Un Archivo Tar"

cd $scripts_path

if test -f backups.tar.gz; then
    print_text "borrando respaldo anterior"
    rm -r backups.tar.gz
fi

print_text "creando respaldo nuevo"

tar -zcvf backups.tar.gz backups
rm -r backups

print_text "respaldo creado"

print_title "Respaldo De Configuraciones Personalizadas Finalizado"
