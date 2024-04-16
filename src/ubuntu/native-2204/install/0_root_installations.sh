#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Iniciando instalaciones"

sudo $scripts_path/../sidecar/update.sh

print_title "01/07 - Instalando programas de snap"

sudo snap install ngrok
sudo snap install postman
sudo snap install spotify
sudo snap install redisinsight
sudo snap install code --classic
sudo snap install beekeeper-studio
sudo snap install kubectl --classic

quiet_update
print_title "02/07 - Desinstalando programas de snap"

sudo snap remove firefox

quiet_update
print_title "03/07 - Instalando programas de repositorios por defecto"

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
	"curl"
	"git"
	"zsh"
)

for the_package in "${default_instalations[@]}"; do
	print_text "Instalando $the_package"
	print_text "Validando instalación del paquete $the_package"
	if dpkg -s $the_package &> /dev/null; then
		print_text "El paquete $the_package está instalado, no hace falta hacer más cambios"
	else
		print_text "El paquete $the_package no está instalado, instalandolo"
		sudo apt-get install -y $the_package
	fi
done

quiet_update
print_title "04/07 - Instalando chrome"

if command -v google-chrome-stable &> /dev/null; then
	print_text "chrome ya está instalado, no hace falta hacer más cambios"
else
	print_text "chrome no está instalado, instalandolo"
	quiet_update
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install -y ./google-chrome-stable_current_amd64.deb
	rm -r google-chrome-stable_current_amd64.deb
fi

quiet_update
print_title "05/07 - Instalando MongoDB-compass"

if command -v mongodb-compass &> /dev/null; then
	print_text "compass ya está instalado, no hace falta hacer más cambios"
else
	print_text "compass no está instalado, instalandolo"
	quiet_update
	wget https://downloads.mongodb.com/compass/mongodb-compass_1.42.0_amd64.deb
	sudo dpkg -i mongodb-compass_1.42.0_amd64.deb
	rm -r mongodb-compass_1.42.0_amd64.deb
fi

quiet_update
print_title "06/07 - Instalando K3S"

if command -v k3S &> /dev/null; then
	print_text "K3S ya está instalado, no hace falta hacer más cambios"
else
	print_text "K3S no está instalado, instalandolo"
	quiet_update
	curl -sfL https://get.k3s.io | sh -
fi

quiet_update
print_title "07/07 - Instalando K6"

if command -v K6 &> /dev/null; then
	print_text "K6 ya está instalado, no hace falta hacer más cambios"
else
	print_text "K6 no está instalado, instalandolo"
	sudo gpg -k
	sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
	echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
	quiet_update
	sudo apt-get install k6
fi

quiet_update
print_title "Instalaciones finalizadas"
