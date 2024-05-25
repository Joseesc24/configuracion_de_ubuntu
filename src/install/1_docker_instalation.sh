#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Starting Installations"

sudo $scripts_path/../sidecar/update.sh

quiet_update
print_title "05/18 - Uninstalling Old Docker-Engine Packages"

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
	print_text "removing $the_package"
	print_text "checking installation of package $the_package"
	if dpkg -s $the_package &> /dev/null; then
		print_text "package $the_package is installed, removing the package"
		sudo apt remove -y $the_package
	else
		print_text "package $the_package is not installed, no further changes needed"
	fi
done

quiet_update
print_title "06/18 - Installing Docker-Engine Prerequisite Packages"

docker_install=(
	"ca-certificates"
	"curl"
)

for the_package in "${docker_install[@]}"; do
	print_text "installing $the_package"
	print_text "checking installation of package $the_package"
	if dpkg -s $the_package &> /dev/null; then
		print_text "package $the_package is installed, no further changes needed"
	else
		print_text "package $the_package is not installed, installing it"
		sudo apt-get install -y $the_package
	fi
done

quiet_update
print_title "07/18 - Installing Docker-Engine Gpg Key"

docker_key=/usr/share/keyrings/docker-archive-keyring.gpg

if test -f $docker_key; then
	print_text "docker-engine gpg key exists at $docker_key"
	sudo rm -r /usr/share/keyrings/docker-archive-keyring.gpg
else
	print_text "docker-engine gpg key does not exist"
fi

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list &> /dev/null

quiet_update
print_title "08/18 - Installing Docker-Engine Packages"

docker_engine_install=(
	"docker-compose-plugin"
	"docker-buildx-plugin"
	"docker-ce-cli"
	"containerd.io"
	"docker-ce"
)

for the_package in "${docker_engine_install[@]}"; do
	print_text "installing $the_package"
	print_text "checking installation of package $the_package"
	if dpkg -s $the_package &> /dev/null; then
		print_text "package $the_package is installed no further changes needed"
	else
		print_text "package $the_package is not installed installing it"
		sudo apt-get install -y $the_package
	fi
done

quiet_update
print_title "Installations Completed"
