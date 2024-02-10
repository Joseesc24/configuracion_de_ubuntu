#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

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

print_title "Instalaciones finalizadas"
