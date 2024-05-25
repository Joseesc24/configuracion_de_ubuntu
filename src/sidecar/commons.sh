#!/bin/bash

print_title() {
	bold=$(tput bold)
	normal=$(tput sgr0)

	title=$1

	set -e

	echo -e
	echo -e "${bold}${title}${normal}"
	echo -e
}

print_text() {
	title=$1

	set -e

	echo -e "${title}"
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
