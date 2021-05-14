#!/bin/bash

set -e

echo -e
sudo -k

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
home=$HOME
user=$USER

sudo -v
echo -e

echo -e "Iniciando instalaciones"

echo -e
sudo $scripts_path/update.sh
echo -e

echo -e "Instalando programas de snap"

sudo snap install ngrok
sudo snap install drawio
sudo snap install spotify
sudo snap install code --classic

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Desinstalando paquetes innecesarios"

docker_uninstall=(
    "gnome-power-manager"
    "gnome-characters"
    "gnome-calculator"
    "firefox"
)

for i in "${docker_uninstall[@]}"; do
    the_package=$i
    echo -e "Eliminando $the_package"
    echo -e "Validando instalación del paquete $the_package"
    if dpkg -s $the_package &>/dev/null; then
        echo -e "El paquete $the_package está instalado, eliminando el paquete"
        sudo apt purge -y $the_package
    else
        echo -e "El paquete $the_package no está instalado, no hace falta hacer más cambios"
    fi
done

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando programas de repositorios externos"

declare -A ppa_instalations=(
    ["indicator-sysmonitor"]="ppa:fossfreedom/indicator-sysmonitor"
    ["timeshift"]="ppa:teejee2008/timeshift"
    ["neofetch"]="ppa:dawidd0811/neofetch"
    ["tilix"]="ppa:ubuntuhandbook1/tilix"
)

for i in "${!ppa_instalations[@]}"; do
    the_package=$i
    the_ppa=${ppa_instalations[$i]}
    echo -e "Instalando $the_package"
    echo -e "Validando instalación del paquete $the_package"
    if dpkg -s $the_package &>/dev/null; then
        echo -e "El paquete $the_package está instalado, no hace falta hacer más cambios"
    else
        echo -e "El paquete $the_package no está instalado, instalandolo"
        echo -e "Validando instalación del repositorio $the_ppa"
        if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
            echo -e "El repositorio $the_ppa no está agregado al sistema de repositorios, agregandolo"
            sudo apt-get update >/dev/null
            sudo add-apt-repository -y $the_ppa
        else
            echo -e "El repositorio $the_ppa ya esta agregado al sistema de repositorios"
        fi
        echo -e "Instalando $the_package"
        sudo apt-get update >/dev/null
        sudo apt-get install -y $the_package
    fi
done

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando programas de repositorios por defecto"

default_instalations=(
    "numix-icon-theme-circle"
    "usb-creator-gtk"
    "gnome-tweaks"
    "authbind"
    "cmatrix"
    "baobab"
    "neovim"
    "tree"
    "htop"
    "git"
    "zsh"
    "vim"
)

for i in "${default_instalations[@]}"; do
    the_package=$i
    echo -e "Instalando $the_package"
    echo -e "Validando instalación del paquete $the_package"
    if dpkg -s $the_package &>/dev/null; then
        echo -e "El paquete $the_package está instalado, no hace falta hacer más cambios"
    else
        echo -e "El paquete $the_package no está instalado, instalandolo"
        sudo apt-get install -y $the_package
    fi
done

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Desinstalando paquetes viejos de docker-engine"

docker_uninstall=(
    "docker-engine"
    "containerd"
    "docker.io"
    "docker"
    "runc"
)

for i in "${docker_uninstall[@]}"; do
    the_package=$i
    echo -e "Eliminando $the_package"
    echo -e "Validando instalación del paquete $the_package"
    if dpkg -s $the_package &>/dev/null; then
        echo -e "El paquete $the_package está instalado, eliminando el paquete"
        sudo apt remove -y $the_package
    else
        echo -e "El paquete $the_package no está instalado, no hace falta hacer más cambios"
    fi
done

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando paquetes requisito de docker-engine"

docker_install=(
    "apt-transport-https"
    "ca-certificates"
    "lsb-release"
    "gnupg"
    "curl"
)

for i in "${docker_install[@]}"; do
    the_package=$i
    echo -e "Instalando $the_package"
    echo -e "Validando instalación del paquete $the_package"
    if dpkg -s $the_package &>/dev/null; then
        echo -e "El paquete $the_package está instalado, no hace falta hacer más cambios"
    else
        echo -e "El paquete $the_package no está instalado, instalandolo"
        sudo apt-get install -y $the_package
    fi
done

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando llave GPG de docker-engine"

docker_key=/usr/share/keyrings/docker-archive-keyring.gpg
if test -f $docker_key; then
    echo "La llave GPG de docker-engine existe en $docker_key"
    sudo rm -r /usr/share/keyrings/docker-archive-keyring.gpg
else
    echo "La llave GPG de docker-engine no existe"
fi

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list &>/dev/null

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando paquetes de docker-engine"

docker_engine_install=(
    "docker-ce-cli"
    "containerd.io"
    "docker-ce"
)

for i in "${docker_engine_install[@]}"; do
    the_package=$i
    echo -e "Instalando $the_package"
    echo -e "Validando instalación del paquete $the_package"
    if dpkg -s $the_package &>/dev/null; then
        echo -e "El paquete $the_package está instalado, no hace falta hacer más cambios"
    else
        echo -e "El paquete $the_package no está instalado, instalandolo"
        sudo apt-get install -y $the_package
    fi
done

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando chrome"

if command -v google-chrome-stable &>/dev/null; then
    echo -e "chrome ya está instalado, no hace falta hacer más cambios"
else
    echo -e "chrome no está instalado, instalandolo"
    sudo apt-get update >/dev/null
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm -r google-chrome-stable_current_amd64.deb
fi

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando dive"

if command -v dive &>/dev/null; then
    echo -e "dive ya está instalado, no hace falta hacer más cambios"
else
    echo -e "dive no está instalado, instalandolo"
    sudo apt-get update >/dev/null
    wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
    sudo apt-get install -y ./dive_0.9.2_linux_amd64.deb
    rm -r dive_0.9.2_linux_amd64.deb
fi

echo -e
echo -e
sudo apt-get update >/dev/null
echo -e "Instalando docker-compose"

if command -v docker-compose &>/dev/null; then
    echo -e "docker-compose ya está instalado, no hace falta hacer más cambios"
else
    echo -e "docker-compose no está instalado, instalandolo"
    sudo apt-get update >/dev/null
    sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

echo -e
sudo $scripts_path/update.sh
echo -e

echo -e "Instalaciones finalizadas"
echo -e
