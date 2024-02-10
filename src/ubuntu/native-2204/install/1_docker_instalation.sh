#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

sudo $scripts_path/../sidecar/update.sh

quiet_update
print_title "05/18 - Desinstalando paquetes viejos de docker-engine"

docker_uninstall=(
    "docker-compose-v2"
    "docker-compose"
    "docker-engine"
    "podman-docker"
    "containerd"
    "docker-doc"
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
    "ca-certificates"
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

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list &>/dev/null

quiet_update
print_title "08/18 - Instalando paquetes de docker-engine"

docker_engine_install=(
    "docker-compose-plugin"
    "docker-buildx-plugin"
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
print_title "Instalaciones finalizadas"
