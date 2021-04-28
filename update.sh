#!/bin/bash
set -e

echo -e
sudo -k

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
home=$HOME
user=$USER

sudo -v
echo -e

echo -e "iniciando actualizaciones"

echo -e
echo -e "actualizando versiones de repositorios y paquetes"
echo -e

sudo apt-get --fix-broken install -y
sudo apt-get update -y --fix-missing

echo -e
echo -e "instalando repositorios y paquetes actualizados"
echo -e

sudo apt-get upgrade -y --fix-missing

echo -e
echo -e "comprobando y actualizando version del kernel"
echo -e

sudo apt-get dist-upgrade -y --fix-missing

echo -e
echo -e "comprobando instalaciones nuevas"
echo -e

sudo apt-get check -y

echo -e
echo -e "reparando paquetes y dependencias dañadas"
echo -e

sudo apt --fix-broken -y install

echo -e
echo -e "eliminando paquetes y repositorios innecesarios"
echo -e

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt remove -y
sudo apt clean -y

echo -e
echo -e "verificando permisos de los scripts personalizados"
sudo find $scripts_path -type f -exec chmod 777 {} \;

echo -e "verificando permisos de los directorios y subdirectorios de $home"
sudo find $home/ -type d -exec chmod 755 {} \;

echo -e
echo -e "actualizaciones finalizadas"
echo -e
