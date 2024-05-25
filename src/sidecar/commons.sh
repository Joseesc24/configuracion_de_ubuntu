#!/bin/bash

print_title() {
	TIT='\033[1;33m'
	NCL='\033[0m'
	title=$1
	set -e
	echo -e
	echo -e "${TIT}${title}${NCL}"
	echo -e
}

print_text() {
	TXT='\033[1;30m'
	NCL='\033[0m'
	title=$1
	set -e
	echo -e "${TXT}${title^}${NCL}"
}

remove_and_ask_password() {
	set -e
	echo -e
	sudo -k
	sudo -v
}

quiet_update() {
	sudo apt-get update > /dev/null
}
