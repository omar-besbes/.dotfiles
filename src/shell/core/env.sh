#!/bin/bash

# Set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# NVIDIA Drivers
export PATH="/usr/local/cuda-12./bin${PATH:+:${PATH}}"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Added by Toolbox App
export PATH="$PATH:/home/omar/.local/share/JetBrains/Toolbox/scripts"

# Rust package manager (cargo)
source "$HOME/.cargo/env"

