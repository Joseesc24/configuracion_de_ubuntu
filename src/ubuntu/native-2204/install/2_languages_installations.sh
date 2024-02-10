#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

sudo $scripts_path/../sidecar/update.sh

quiet_update
print_title "01/05 - Instalando python 3.12.0"

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
    tar -xvf Python-3.12.0.tar.xz
    cd Python-3.12.0
    sudo ./configure --enable-optimizations
    sudo make altinstall
    cd ..
    cd ..
    rm -r python
fi

quiet_update
print_title "02/05 - Instalando poetry latest"

if command -v poetry &>/dev/null; then
    print_text "poetry ya está instalado, no hace falta hacer más cambios"
else
    print_text "poetry no está instalado, instalandolo"
    quiet_update
    curl -sSL https://install.python-poetry.org | python3 -
fi

quiet_update
print_title "03/05 - Instalando rust latest"

if command -v rustup &>/dev/null; then
    print_text "rust ya está instalado, no hace falta hacer más cambios"
else
    print_text "rust no está instalado, instalandolo"
    quiet_update
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
    sh rustup.sh -y
    rm -rf rustup.sh
fi

quiet_update
print_title "04/05 - Instalando nodejs 20.8.0"

if command -v node &>/dev/null; then
    print_text "nodejs ya está instalado, no hace falta hacer más cambios"
else
    print_text "nodejs no está instalado, instalandolo"
    quiet_update
    mkdir node
    cd node
    wget https://nodejs.org/dist/v20.8.0/node-v20.8.0-linux-x64.tar.xz
    tar -xvf node-v20.8.0-linux-x64.tar.xz
    sudo cp -r node-v20.8.0-linux-x64/{bin,include,lib,share} /usr/
    cd ..
    rm -r node
fi

quiet_update
print_title "05/05 - Instalando go 1.21.1"

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

print_title "Instalaciones finalizadas"
