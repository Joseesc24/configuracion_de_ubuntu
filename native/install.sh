#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

sudo $scripts_path/update.sh

print_title "01/14 - Instalando programas de snap"

sudo snap install ngrok
sudo snap install drawio
sudo snap install postman
sudo snap install spotify
sudo snap install remmina
sudo snap install brave
sudo snap install code --classic
sudo snap install beekeeper-studio
sudo snap install telegram-desktop

quiet_update
print_title "02/14 - Desinstalando paquetes innecesarios"

sudo snap remove firefox

uninstall=(
    "gnome-power-manager"
    "gnome-characters"
    "gnome-calculator"
    "imagemagick"
)

for the_package in "${uninstall[@]}"; do

    print_text "Eliminando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

        print_text "El paquete $the_package está instalado, eliminando el paquete"

        sudo apt purge -y $the_package

    else

        print_text "El paquete $the_package no está instalado, no hace falta hacer más cambios"

    fi

done

quiet_update
print_title "03/14 - Instalando programas de repositorios externos"

declare -A ppa_instalations=(
    ["deadsnakes"]="ppa:deadsnakes/ppa"
)

for i in "${!ppa_instalations[@]}"; do

    the_package=$i
    the_ppa=${ppa_instalations[$i]}

    print_text "Instalando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then

        print_text "El paquete $the_package está instalado, no hace falta hacer más cambios"

    else

        print_text "El paquete $the_package no está instalado, instalandolo"
        print_text "Validando instalación del repositorio $the_ppa"

        if ! grep -q "^deb .*$the_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then

            print_text "El repositorio $the_ppa no está agregado al sistema de repositorios, agregandolo"

            quiet_update
            sudo add-apt-repository -y $the_ppa

        else

            print_text "El repositorio $the_ppa ya esta agregado al sistema de repositorios"

        fi

        print_text "Instalando $the_package"

        quiet_update
        sudo apt-get install -y $the_package

    fi

done

quiet_update
print_title "04/14 - Instalando programas de repositorios por defecto"

default_instalations=(
    "software-properties-common"
    "gir1.2-appindicator3-0.1"
    "numix-icon-theme-circle"
    "usb-creator-gtk"
    "openjdk-11-jre"
    "openjdk-11-jdk"
    "python3-psutil"
    "gconf2-common"
    "libgconf-2-4"
    "python3-venv"
    "virtualenv"
    "timeshift"
    "python3.10"
    "authbind"
    "neofetch"
    "cmatrix"
    "preload"
    "baobab"
    "nodejs"
    "deluge"
    "neovim"
    "golang"
    "gnupg"
    "steam"
    "tilix"
    "tree"
    "htop"
    "git"
    "zsh"
    "vim"
    "npm"
    "vlc"
)

for the_package in "${default_instalations[@]}"; do

    print_text "Instalando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

        print_text "El paquete $the_package está instalado, no hace falta hacer más cambios"

    else

        print_text "El paquete $the_package no está instalado, instalandolo"

        sudo apt-get install -y $the_package

    fi

done

quiet_update
print_title "05/14 - Desinstalando paquetes viejos de docker-engine"

docker_uninstall=(
    "docker-engine"
    "containerd"
    "docker.io"
    "docker"
    "runc"
)

for the_package in "${docker_uninstall[@]}"; do

    print_text "Eliminando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

        print_text "El paquete $the_package está instalado, eliminando el paquete"

        sudo apt remove -y $the_package

    else

        print_text "El paquete $the_package no está instalado, no hace falta hacer más cambios"

    fi

done

quiet_update
print_title "06/14 - Instalando paquetes requisito de docker-engine"

docker_install=(
    "apt-transport-https"
    "ca-certificates"
    "lsb-release"
    "gnupg"
    "curl"
)

for the_package in "${docker_install[@]}"; do

    print_text "Instalando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

        print_text "El paquete $the_package está instalado, no hace falta hacer más cambios"

    else

        print_text "El paquete $the_package no está instalado, instalandolo"
        sudo apt-get install -y $the_package

    fi

done

quiet_update
print_title "07/14 - Instalando llave GPG de docker-engine"

docker_key=/usr/share/keyrings/docker-archive-keyring.gpg

if test -f $docker_key; then

    print_text "La llave GPG de docker-engine existe en $docker_key"
    sudo rm -r /usr/share/keyrings/docker-archive-keyring.gpg

else

    print_text "La llave GPG de docker-engine no existe"

fi

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list &>/dev/null

quiet_update
print_title "08/14 - Instalando paquetes de docker-engine"

docker_engine_install=(
    "docker-ce-cli"
    "containerd.io"
    "docker-ce"
)

for the_package in "${docker_engine_install[@]}"; do

    print_text "Instalando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

        print_text "El paquete $the_package está instalado, no hace falta hacer más cambios"

    else

        print_text "El paquete $the_package no está instalado, instalandolo"

        sudo apt-get install -y $the_package

    fi

done

quiet_update
print_title "11/14 - Instalando chrome"

if command -v google-chrome-stable &>/dev/null; then

    print_text "chrome ya está instalado, no hace falta hacer más cambios"

else

    print_text "chrome no está instalado, instalandolo"

    quiet_update

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm -r google-chrome-stable_current_amd64.deb

fi

quiet_update
print_title "12/14 - Instalando dive"

if command -v dive &>/dev/null; then

    print_text "dive ya está instalado, no hace falta hacer más cambios"

else

    print_text "dive no está instalado, instalandolo"

    quiet_update

    wget https://github.com/wagoodman/dive/releases/download/v0.9.2/dive_0.9.2_linux_amd64.deb
    sudo apt-get install -y ./dive_0.9.2_linux_amd64.deb
    rm -r dive_0.9.2_linux_amd64.deb

fi

quiet_update
print_title "14/14 - Instalando docker-compose"

if command -v docker-compose &>/dev/null; then

    print_text "docker-compose ya está instalado, no hace falta hacer más cambios"

else

    print_text "docker-compose no está instalado, instalandolo"

    quiet_update

    sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

fi

quiet_update
print_title "15/15 - Instalando indicator-sysmonitor"

if command -v indicator-sysmonitor &>/dev/null; then

    print_text "indicator-sysmonitor ya está instalado, no hace falta hacer más cambios"

else

    print_text "indicator-sysmonitor no está instalado, instalandolo"

    quiet_update

    git clone https://github.com/wdbm/indicator-sysmonitor.git
    cd indicator-sysmonitor
    sudo make install
    cd ..
    rm -rf indicator-sysmonitor

fi


sudo $scripts_path/update.sh

print_title "Instalaciones finalizadas"
