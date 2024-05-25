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

copy_checking_source_and_destination() {
	source_path=$1
	destination_path=$2
	create_directory_if_not_exists $destination_path
	if test -f $source_path; then
		print_text "Source path $source_path is a file"
		print_text "Copying file from $source_path to $destination_path"
		cp -r $source_path $destination_path
	elif test -d $source_path; then
		print_text "Source path $source_path is a directory"
		print_text "Copying contents from $source_path to $destination_path"
		cp -r $source_path/* $destination_path
	else
		print_text "Source path $source_path does not exist"
	fi
}

print_title "Starting Custom Configurations Backup"

print_title "01/03 - Backing Up Custom Font Configurations"

backup_fonts_path=$backup_path/fonts
source_fonts_path=$home/.fonts
copy_checking_source_and_destination $source_fonts_path $backup_fonts_path

print_title "02/03 - Backing Up Zsh Configurations"

backup_zsh_path=$backup_path/zsh
source_zsh_path_1=$home/.p10k.zsh
source_zsh_path_2=$home/.zshrc
copy_checking_source_and_destination $source_zsh_path_1 $backup_zsh_path
copy_checking_source_and_destination $source_zsh_path_2 $backup_zsh_path

print_title "03/03 - Compressing Backup Into a Tar File"

create_directory_if_not_exists $tar_path
cd $tar_path

if test -f backup.tar.gz; then
	print_text "Deleting previous backup"
	rm -r backup.tar.gz
fi

print_text "Creating new backup"

tar -zcvf backup.tar.gz $backup_path
rm -r $backup_path

print_text "Backup created"

print_title "Custom Configurations Backup Finished"
