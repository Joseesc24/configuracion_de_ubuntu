#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Starting Installations"

sudo $scripts_path/../sidecar/update.sh

print_title "01/06 - Installing Snap Programs"

sudo snap install ngrok
sudo snap install postman
sudo snap install spotify
sudo snap install kustomize
sudo snap install redisinsight
snap install microk8s --classic
sudo snap install helm --classic
sudo snap install code --classic
sudo snap install beekeeper-studio
sudo snap install kubectl --classic

quiet_update
print_title "02/06 - Uninstalling Snap Programs"

sudo snap remove firefox

quiet_update
print_title "03/06 - Installing Default Repository Programs"

default_instalations=(
	"software-properties-common"
	"usb-creator-gtk"
	"net-tools"
	"timeshift"
	"neofetch"
	"preload"
	"unrar"
	"tree"
	"curl"
	"nmap"
	"wget"
	"git"
	"zsh"
	"rar"
)

for the_package in "${default_instalations[@]}"; do
	print_text "installing $the_package"
	print_text "validating installation of package $the_package"
	if dpkg -s $the_package &> /dev/null; then
		print_text "package $the_package is already installed no further changes needed"
	else
		print_text "package $the_package is not installed installing it"
		sudo apt-get install -y $the_package
	fi
done

quiet_update
print_title "04/06 - Installing Chrome"

if command -v google-chrome-stable &> /dev/null; then
	print_text "google chrome is already installed no further changes needed"
else
	print_text "google chrome is not installed installing it"
	quiet_update
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install -y ./google-chrome-stable_current_amd64.deb
	rm -r google-chrome-stable_current_amd64.deb
fi

quiet_update
print_title "05/06 - Installing Mongodb-Compass"

if command -v mongodb-compass &> /dev/null; then
	print_text "compass is already installed no further changes needed"
else
	print_text "compass is not installed installing it"
	quiet_update
	wget https://downloads.mongodb.com/compass/mongodb-compass_1.43.0_amd64.deb
	sudo dpkg -i mongodb-compass_1.43.0_amd64.deb
	rm -r mongodb-compass_1.43.0_amd64.deb
fi

quiet_update
print_title "06/06 - Installing K6"

if command -v K6 &> /dev/null; then
	print_text "k6 is already installed no further changes needed"
else
	print_text "k6 is not installed installing it"
	sudo gpg -k
	sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
	echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
	quiet_update
	sudo apt-get install k6
fi

quiet_update
print_title "Installations Completed"
