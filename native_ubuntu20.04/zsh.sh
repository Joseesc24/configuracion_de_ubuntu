#!/bin/bash

set -e

echo -e
sudo -k

home=$HOME
user=$USER

sudo -v
echo -e

echo -e "iniciando istalación y configuración de zsh"

echo -e
echo -e "instalando zsh"

the_package="zsh"
if dpkg -s $the_package &>/dev/null; then
    echo -e "$the_package ya está instalado, no hace falta hacer más cambios"
else
    echo -e "$the_package no está instalado, instalandolo $the_package"
    echo -e
    sudo apt-get install -y $the_package
fi

echo -e
echo -e "configurando zsh como shell por defecto"
sudo usermod --shell $(which zsh) $user >/dev/null

echo -e
echo -e "instalando oh-my-zsh"

folder_path=$home/.oh-my-zsh
if test -d $folder_path; then
    echo -e "oh-my-zsh ya está instalado, no hace falta hacer más cambios"
else
    echo -e "oh-my-zsh no esta instalado, instalando oh-my-zsh"
    echo -e
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    zsh &
fi

echo -e
echo -e "instalando plugins oficiales de oh-my-zsh"

zsh_official_plugins=(
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
)

for plugin in "${zsh_official_plugins[@]}"; do
    folder_path=${ZSH_CUSTOM:-$home/.oh-my-zsh/custom}/plugins/$plugin
    if test -d $folder_path; then
        echo -e "$plugin ya está instalado, no hace falta hacer más cambios"
    else
        echo -e "$plugin no esta instalado, instalando $plugin"
        echo -e
        git clone https://github.com/zsh-users/$plugin $folder_path
    fi
done

echo -e
echo -e "instalando powerlevel10k para oh-my-zsh"

folder_path=${ZSH_CUSTOM:-$home/.oh-my-zsh/custom}/themes/powerlevel10k
if test -d $folder_path; then
    echo -e "powerlevel10k ya está instalado, no hace falta hacer más cambios"
else
    echo -e "powerlevel10k no está instalado, instalando powerlevel10k"
    echo -e
    git clone --depth=1 https://github.com/romkatv/powerlevel10k $folder_path
fi

echo -e
echo -e "istalación y configuración de zsh finalizada, reinicie su terminal"
echo -e
