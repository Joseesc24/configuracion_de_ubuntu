#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh
backup_path=$scripts_path/../backup
tar_path=$scripts_path/../snapshot

home=$HOME
user=$USER

remove_and_ask_password

create_directory_if_not_exists() {
	if test -d $1; then
		print_text "Directory $1 already exists"
	else
		print_text "Directory $1 does not exist"
		print_text "Creating directory $1"
		mkdir -p $1
	fi
}

replace_checking_source_and_destination() {
	source_path=$1
	destination_path=$2
	create_directory_if_not_exists $destination_path
	if test -f $source_path; then
		print_text "The path $source_path is for a file"
		print_text "Copying the file from $source_path to $destination_path"
		cp -r -f $source_path $destination_path
	elif test -d $source_path; then
		print_text "The path $source_path is for a directory"
		print_text "Copying the contents from $source_path to $destination_path"
		cp -r -f $source_path/* $destination_path
	else
		print_text "The source path $source_path does not exist"
	fi
}

print_title "Starting Custom Configurations Restore"

print_title "01/05 - Extracting Backup Directory"

cd $tar_path

if test -f backup.tar.gz; then
	print_text "Backup found"
	tar xzf backup.tar.gz backup
else
	print_text "Backup not found, aborting restore"
	print_title "Custom Configurations Restore Aborted"
	exit 1
fi

print_title "02/05 - Restoring Custom Fonts Configurations"

backup_fonts_path=$backup_path/fonts
source_fonts_path=$home/.fonts
replace_checking_source_and_destination $backup_fonts_path $source_fonts_path

print_title "03/05 - Restoring Zsh and P10k Configurations"

backup_zsh_1_path=$backup_path/zsh/.p10k.zsh
backup_zsh_2_path=$backup_path/zsh/.zshrc
source_zsh_path=$home
replace_checking_source_and_destination $backup_zsh_1_path $source_zsh_path
replace_checking_source_and_destination $backup_zsh_2_path $source_zsh_path

print_title "04/05 - Restoring Docker Engine Configurations"

if grep -q docker /etc/group; then
	print_text "The docker group already exists, no further changes needed"
else
	print_text "The docker group does not exist, creating docker group"
	sudo addgroup --system docker
fi

if getent group docker | grep -q "\b$user\b"; then
	print_text "The user $user already belongs to the docker group, no further changes needed"
else
	print_text "The user $user does not belong to the docker group yet, adding $user to the docker group"
	sudo adduser $user docker
fi

print_title "05/05 - Removing Backup Directory"

rm -r backup
print_text "Backup directory removed"

print_title "Custom Configurations Restore Completed"
