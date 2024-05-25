#!/bin/bash

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
source $scripts_path/../sidecar/commons.sh

print_title "Starting Languages Configuration"

echo "export PATH=$HOME/.cargo/bin:$HOME/.local/bin:/usr/node-v20.8.0-linux-x64/bin:/usr/local/go/bin:$PATH" | tee -a ~/.bashrc
source ~/.bashrc

print_title "Languages Configuration Completed"
