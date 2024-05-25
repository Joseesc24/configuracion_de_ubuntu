#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

home=$HOME
user=$USER

remove_and_ask_password

print_title "Starting Updates"

print_title "01/08 - Updating Repository And Package Versions"

sudo apt-get update -y --fix-missing

print_title "02/08 - Installing Updated Repositories And Packages"

sudo apt-get --fix-broken install -y
sudo apt-get upgrade -y --fix-missing

print_title "03/08 - Checking And Updating Kernel Version"

sudo apt-get dist-upgrade -y --fix-missing

print_title "04/08 - Checking New Installations"

sudo apt-get check -y

print_title "05/08 - Repairing Damaged Packages And Dependencies"

sudo apt --fix-broken -y install

print_title "06/08 - Removing Unnecessary Packages And Repositories"

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt remove -y
sudo apt clean -y

print_title "07/08 - Verifying Permissions Of Custom Scripts"

sudo find $scripts_path -type f -exec chmod 777 {} \;

print_text "permission verification completed"

print_title "08/08 - Verifying Permissions Of Home Directory And Subdirectories"

sudo find $home/ -type d -exec chmod 755 {} \;

print_text "permission verification completed"

print_title "Updates Completed"
