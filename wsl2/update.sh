#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/commons.sh

home=$HOME
user=$USER

remove_and_ask_password

print_title "Iniciando Actualizaciones"

print_title "1/6 - Actualizando Versiones De Repositorios Y Paquetes"

sudo apt-get update -y --fix-missing

print_title "2/6 - Instalando Repositorios Y Paquetes Actualizados"

sudo apt-get --fix-broken install -y
sudo apt-get upgrade -y --fix-missing

print_title "3/6 - Comprobando Y Actualizando Version Del Kernel"

sudo apt-get dist-upgrade -y --fix-missing

print_title "4/6 - Comprobando Instalaciones Nuevas"

sudo apt-get check -y

print_title "5/6 - Reparando Paquetes Y Dependencias Dañadas"

sudo apt --fix-broken -y install

print_title "6/6 - Eliminando Paquetes Y Repositorios Innecesarios"

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt remove -y
sudo apt clean -y

print_title "Actualizaciones Finalizadas"
