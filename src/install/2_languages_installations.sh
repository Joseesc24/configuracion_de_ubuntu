#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Starting Installations"

sudo $scripts_path/../sidecar/update.sh

quiet_update
print_title "01/05 - Installing Python 3.12.3"

if command -v python3.12.0 &> /dev/null; then
	print_text "python3.12 is already installed, no further changes needed"
else
	print_text "python3.12 is not installed, installing"
	quiet_update
	mkdir python
	cd python
	sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
	quiet_update
	wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tar.xz
	tar -xvf Python-3.12.3.tar.xz
	cd Python-3.12.3
	sudo ./configure --enable-optimizations
	sudo make altinstall
	cd ..
	cd ..
	sudo rm -r python
fi

quiet_update
print_title "02/05 - Installing Poetry Latest"

if command -v poetry &> /dev/null; then
	print_text "poetry is already installed, no further changes needed"
else
	print_text "poetry is not installed, installing"
	quiet_update
	curl -sSL https://install.python-poetry.org | python3.12 -
fi

quiet_update
print_title "03/05 - Installing Rust Latest"

if command -v rustup &> /dev/null; then
	print_text "rust is already installed, no further changes needed"
else
	print_text "rust is not installed, installing"
	quiet_update
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
	sh rustup.sh -y
	rm -rf rustup.sh
fi

quiet_update
print_title "04/05 - Installing Nodejs 22.2.0"

if command -v node &> /dev/null; then
	print_text "nodejs is already installed, no further changes needed"
else
	print_text "nodejs is not installed, installing"
	quiet_update
	mkdir node
	cd node
	wget https://nodejs.org/dist/v22.2.0/node-v22.2.0-linux-x64.tar.xz
	tar -xvf node-v22.2.0-linux-x64.tar.xz
	sudo cp -r node-v22.2.0-linux-x64/{bin,include,lib,share} /usr/
	cd ..
	rm -r node
fi

quiet_update
print_title "05/05 - Installing Go 1.22.3"

if command -v go &> /dev/null; then
	print_text "go is already installed, no further changes needed"
else
	print_text "go is not installed, installing"
	quiet_update
	mkdir golang
	cd golang
	wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz
	rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz
	cd ..
	rm -r golang
fi

print_title "Installations Completed"
