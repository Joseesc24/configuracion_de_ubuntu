#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

home=$HOME
user=$USER

remove_and_ask_password

print_title "Iniciando Actualizaciones"

print_title "01/08 - Actualizando Versiones De Repositorios Y Paquetes"

sudo apt-get update -y --fix-missing

print_title "02/08 - Instalando Repositorios Y Paquetes Actualizados"

sudo apt-get --fix-broken install -y
sudo apt-get upgrade -y --fix-missing

print_title "03/08 - Comprobando Y Actualizando Version Del Kernel"

sudo apt-get dist-upgrade -y --fix-missing

print_title "04/08 - Comprobando Instalaciones Nuevas"

sudo apt-get check -y

print_title "05/08 - Reparando Paquetes Y Dependencias Dañadas"

sudo apt --fix-broken -y install

print_title "06/08 - Eliminando Paquetes Y Repositorios Innecesarios"

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt remove -y
sudo apt clean -y

print_title "07/08 - Verificando Permisos De Los Scripts Personalizados"

sudo find $scripts_path -type f -exec chmod 777 {} \;

print_text "verificación de permisos finalizada"

print_title "08/08 - Verificando Permisos De Los Directorios Y Subdirectorios De Home"

sudo find $home/ -type d -exec chmod 755 {} \;

print_text "verificación de permisos finalizada"

print_title "Actualizaciones Finalizadas"
