#!/bin/bash

set -e

echo -e
sudo -k
sudo -v
echo -e

echo -e "Iniciando instalaciones"

echo -e
echo -e

sudo apt-get update >/dev/null

echo -e "Instalando repositorios externos"

sudo add-apt-repository -y ppa:deadsnakes/ppa

echo -e
echo -e

sudo apt-get update >/dev/null

echo -e "Instalando programas de repositorios por defecto"

default_instalations=(
    "postgresql-contrib"
    "redis-server"
    "virtualenv"
    "postgresql"
    "python3.7"
    "nodejs"
    "npm"
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

echo -e "Instalando Go"

if command -v go &>/dev/null; then

    echo -e "go ya está instalado, no hace falta hacer más cambios"

else

    echo -e "go no está instalado, instalandolo"

    sudo apt-get update >/dev/null

    wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz
    sudo rm -r go1.17.3.linux-amd64.tar.gz

    sudo echo "export GOPATH=$HOME/go" >>~/.profile
    sudo echo "export PATH=$PATH:$GOPATH/bin" >>~/.profile
    sudo echo "export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin" >>~/.profile

    source ~/.profile

fi
