#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

remove_and_ask_password

print_title "Starting Installations"

sudo $scripts_path/../sidecar/update.sh

quiet_update
print_title "01/08 - Installing Python 3.13.1 Latest"

if command -v python3.13.0 &> /dev/null; then
	print_text "python3.13 is already installed, no further changes needed"
else
	print_text "python3.13 is not installed, installing"
	quiet_update
	mkdir python
	cd python
	sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget
	quiet_update
	wget https://www.python.org/ftp/python/3.13.1/Python-3.13.1.tar.xz
	tar -xvf Python-3.13.1.tar.xz
	cd Python-3.13.1
	sudo ./configure --enable-optimizations
	sudo make altinstall
	cd ..
	cd ..
	sudo rm -r python
fi

quiet_update
print_title "02/08 - Installing Poetry Latest"

if command -v poetry &> /dev/null; then
	print_text "poetry is already installed, no further changes needed"
else
	print_text "poetry is not installed, installing"
	quiet_update
	curl -sSL https://install.python-poetry.org | python3.13 -
fi

quiet_update
print_title "03/08 - Installing Rust Latest"

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
print_title "04/08 - Installing Nodejs 22.13.1 LTS"

if command -v node &> /dev/null; then
	print_text "nodejs is already installed, no further changes needed"
else
	print_text "nodejs is not installed, installing"
	quiet_update
	mkdir node
	cd node
	wget https://nodejs.org/dist/v22.13.1/node-v22.13.1-linux-x64.tar.xz
	tar -xvf node-v22.13.1-linux-x64.tar.xz
	sudo cp -r node-v22.13.1-linux-x64/{bin,include,lib,share} /usr/
	cd ..
	rm -r node
fi

quiet_update
print_title "05/08 - Installing Go 1.23.5 Stable"

if command -v go &> /dev/null; then
	print_text "go is already installed, no further changes needed"
else
	print_text "go is not installed, installing"
	quiet_update
	mkdir golang
	cd golang
	wget https://go.dev/dl/go1.23.5.linux-amd64.tar.gz
	rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go1.23.5.linux-amd64.tar.gz
	cd ..
	rm -r golang
fi

quiet_update
print_title "03/08 - Installing Bun 1.2.0 Latest"

if command -v bun &> /dev/null; then
	print_text "bun is already installed, no further changes needed"
else
	print_text "bun is not installed, installing"
	quiet_update
	curl -fsSL https://bun.sh/install | bash -s "bun-v1.2.0"
fi

quiet_update
print_title "03/08 - Installing Java 21 LTS"

if command -v java &> /dev/null; then
	print_text "java is already installed, no further changes needed"
else
	print_text "java is not installed, installing"
	quiet_update
	mkdir java
	cd java
	wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
	cd ..
	rm -r java
fi

quiet_update
print_title "03/08 - Installing Ollama"

if command -v ollama &> /dev/null; then
	print_text "ollama is already installed, no further changes needed"
else
	print_text "ollama is not installed, installing"
	quiet_update
	sudo curl -fsSL https://ollama.com/install.sh | sh
fi

print_title "Installations Completed"
