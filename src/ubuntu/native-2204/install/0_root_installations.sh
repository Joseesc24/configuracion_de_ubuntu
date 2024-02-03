#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

sudo $scripts_path/update.sh

print_title "01/18 - Instalando programas de snap"

sudo snap install ngrok
sudo snap install postman
sudo snap install spotify
sudo snap install redisinsight
sudo snap install code --classic
sudo snap install beekeeper-studio

quiet_update
print_title "02/18 - Desinstalando paquetes innecesarios"

sudo snap remove firefox

quiet_update
print_title "04/18 - Instalando programas de repositorios por defecto"

default_instalations=(
    "software-properties-common"
    "numix-icon-theme-circle"
    "python-is-python3"
    "usb-creator-gtk"
    "openjdk-11-jre"
    "openjdk-11-jdk"
    "python3-psutil"
    "gconf2-common"
    "libgconf-2-4"
    "virtualenv"
    "timeshift"
    "authbind"
    "neofetch"
    "preload"
    "gnupg"
    "tree"
    "git"
    "zsh"
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
print_title "05/18 - Desinstalando paquetes viejos de docker-engine"

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
print_title "06/18 - Instalando paquetes requisito de docker-engine"

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
print_title "07/18 - Instalando llave GPG de docker-engine"

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
print_title "08/18 - Instalando paquetes de docker-engine"

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
print_title "09/18 - Instalando chrome"

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
print_title "11/18 - Instalando MongoDB-compass"

if command -v mongodb-compass &>/dev/null; then

    print_text "compass ya está instalado, no hace falta hacer más cambios"

else

    print_text "compass no está instalado, instalandolo"

    quiet_update

    wget https://downloads.mongodb.com/compass/mongodb-compass_1.40.2_amd64.deb
    sudo dpkg -i mongodb-compass_1.40.2_amd64.deb
    rm -r mongodb-compass_1.40.2_amd64.deb

fi

quiet_update
print_title "12/18 - Instalando docker-compose"

if command -v docker-compose &>/dev/null; then

    print_text "docker-compose ya está instalado, no hace falta hacer más cambios"

else

    print_text "docker-compose no está instalado, instalandolo"

    quiet_update

    sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

fi

quiet_update
print_title "14/18 - Instalando python"

if command -v python3.12 &>/dev/null; then

    print_text "python3.12 ya está instalado, no hace falta hacer más cambios"

else

    print_text "python3.12 no está instalado, instalandolo"

    quiet_update

    mkdir python
    cd python
    sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
    quiet_update
    wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tar.xz
    sudo tar -xvf Python-3.12.0.tar.xz
    cd Python-3.12.0
    sudo ./configure --enable-optimizations
    sudo make altinstall
    cd ..
    cd ..
    sudo rm -r python

fi

quiet_update
print_title "15/18 - Instalando poetry"

if command -v poetry &>/dev/null; then

    print_text "poetry ya está instalado, no hace falta hacer más cambios"

else

    print_text "poetry no está instalado, instalandolo"

    quiet_update

    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="/home/jose/.local/bin:$PATH

fi

quiet_update
print_title "16/18 - Instalando rust"

if command -v rustup &>/dev/null; then

    print_text "rust ya está instalado, no hace falta hacer más cambios"

else

    print_text "rust no está instalado, instalandolo"

    quiet_update

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs >rustup.sh
    sh rustup.sh -y
    sudo rm -rf rustup.sh
    source "$HOME/.cargo/env"

fi

quiet_update
print_title "17/18 - Instalando nodejs"

if command -v node &>/dev/null; then

    print_text "nodejs ya está instalado, no hace falta hacer más cambios"

else

    print_text "nodejs no está instalado, instalandolo"

    quiet_update

    mkdir node
    cd node
    wget https://nodejs.org/dist/v20.8.0/node-v20.8.0-linux-x64.tar.xz
    sudo tar -xvf node-v20.8.0-linux-x64.tar.xz
    sudo cp -r node-v20.8.0-linux-x64/{bin,include,lib,share} /usr/
    cd ..
    sudo rm -r node

fi

quiet_update
print_title "18/18 - Instalando go"

if command -v go &>/dev/null; then

    print_text "go ya está instalado, no hace falta hacer más cambios"

else

    print_text "go no está instalado, instalandolo"

    quiet_update

    mkdir golang
    cd golang
    wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
    rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.21.1.linux-amd64.tar.gz
    cd ..
    rm -r golang

fi

echo "export PATH=/usr/node-v20.8.0-linux-x64/bin:/usr/local/go/bin:$PATH" | tee -a ~/.bashrc
source ~/.bashrc

sudo $scripts_path/update.sh

print_title "Instalaciones finalizadas"
