#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

home=$HOME
user=$USER

remove_and_ask_password

print_title "Initializing Zsh Installation And Configuration"

print_title "01/05 - Installing Zsh"

the_package="zsh"

if dpkg -s $the_package &> /dev/null; then
	print_text "$the_package is already installed no further changes needed"
else
	print_text "$the_package is not installed installing $the_package"
	sudo apt-get install -y $the_package
fi

print_title "02/05 - Configuring Zsh As Default Shell"

sudo usermod --shell $(which zsh) $user > /dev/null

print_title "03/05 - Installing Oh-My-Zsh"

folder_path=$home/.oh-my-zsh

if test -d $folder_path; then
	print_text "oh-my-zsh is already installed no further changes needed"
else
	print_text "oh-my-zsh is not installed installing oh-my-zsh"
	curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
	zsh &
fi

print_title "04/05 - Installing Official Oh-My-Zsh Plugins"

zsh_official_plugins=(
	"zsh-syntax-highlighting"
	"zsh-autosuggestions"
)

for plugin in "${zsh_official_plugins[@]}"; do
	folder_path=${ZSH_CUSTOM:-$home/.oh-my-zsh/custom}/plugins/$plugin
	if test -d $folder_path; then
		print_text "$plugin is already installed no further changes needed"
	else
		print_text "$plugin is not installed installing $plugin"
		git clone https://github.com/zsh-users/$plugin $folder_path
	fi
done

print_title "05/05 - Installing Powerlevel10k For Oh-My-Zsh"

folder_path=${ZSH_CUSTOM:-$home/.oh-my-zsh/custom}/themes/powerlevel10k

if test -d $folder_path; then
	print_text "powerlevel10k is already installed no further changes needed"
else
	print_text "powerlevel10k is not installed installing powerlevel10k"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k $folder_path
fi

echo "exec zsh" | tee -a ~/.bashrc
source ~/.bashrc

print_title "Zsh Installation And Configuration Completed Please Restart Your Terminal"
