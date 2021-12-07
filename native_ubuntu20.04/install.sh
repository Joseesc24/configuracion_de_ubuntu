#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

sudo $scripts_path/update.sh

print_title "1/14 - Instalando programas de snap"

sudo snap install vlc
sudo snap install ngrok
sudo snap install drawio
sudo snap install spotify
sudo snap install code --classic
sudo snap install beekeeper-studio
sudo snap install telegram-desktop

quiet_update
print_title "2/14 - Desinstalando paquetes innecesarios"

uninstall=(
    "gnome-power-manager"
    "gnome-characters"
    "gnome-calculator"
    "firefox"
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
print_title "3/14 - Instalando programas de repositorios externos"

sudo add-apt-repository -y ppa:deadsnakes/ppa

declare -A ppa_instalations=(
    ["indicator-sysmonitor"]="ppa:fossfreedom/indicator-sysmonitor"
    ["timeshift"]="ppa:teejee2008/timeshift"
    ["neofetch"]="ppa:dawidd0811/neofetch"
    ["tilix"]="ppa:ubuntuhandbook1/tilix"
)

for i in "${!ppa_instalations[@]}"; do

    the_package=$i
    the_ppa=${ppa_instalations[$i]}

    print_text "Instalando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

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
print_title "4/14 - Instalando programas de repositorios por defecto"

default_instalations=(
    "numix-icon-theme-circle"
    "postgresql-contrib"
    "usb-creator-gtk"
    "gconf2-common"
    "libgconf-2-4"
    "gnome-tweaks"
    "redis-server"
    "postgresql"
    "authbind"
    "preload"
    "sqlite3"
    "baobab"
    "deluge"
    "neovim"
    "gnupg"
    "tree"
    "htop"
    "git"
    "zsh"
    "vim"
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
print_title "5/14 - Desinstalando paquetes viejos de docker-engine"

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
print_title "6/14 - Instalando paquetes requisito de docker-engine"

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
print_title "7/14 - Instalando llave GPG de docker-engine"

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
print_title "8/14 - Instalando paquetes de docker-engine"

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
print_title "9/14 - Instalando llave de MongoDB"

wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add - &>/dev/null
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list &>/dev/null

quiet_update
print_title "10/14 - Instalando paquetes de MongoDB"

mongodb_install=(
    "mongodb-org"
)

for the_package in "${mongodb_install[@]}"; do

    print_text "Instalando $the_package"
    print_text "Validando instalación del paquete $the_package"

    if dpkg -s $the_package &>/dev/null; then

        print_text "El paquete $the_package está instalado, no hace falta hacer más cambios"

    else

        print_text "El paquete $the_package no está instalado, instalandolo"

        quiet_update

        sudo apt-get install -y $the_package

    fi

done

sudo systemctl daemon-reload
sudo systemctl enable mongod

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
print_title "13/14 - Instalando MongoDB-compass"

if command -v mongodb-compass &>/dev/null; then

    print_text "compass ya está instalado, no hace falta hacer más cambios"

else

    print_text "compass no está instalado, instalandolo"

    quiet_update

    wget https://downloads.mongodb.com/compass/mongodb-compass_1.26.1_amd64.deb
    sudo dpkg -i mongodb-compass_1.26.1_amd64.deb
    rm -r mongodb-compass_1.26.1_amd64.deb

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

sudo $scripts_path/update.sh

print_title "Instalaciones finalizadas"
