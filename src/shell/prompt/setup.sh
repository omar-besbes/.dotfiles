#!/bin/bash

# source scripts
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# Make sure to install the latest version of starship, if starship is not installed
declare -r STARHIP_INSTALL_SCRIPT_URL="https://starship.rs/install.sh"
[ ! cmd_exists starship ] && curl -sS $STARHIP_INSTALL_SCRIPT_URL | sh

# Adjust config files
declare -r TOPIC_NAME="shell/prompt"
declare -r TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"
declare -a FILES_TO_SYMLINK=(
	"starship.toml",
)	

symlink_files $FILES_TO_SYMLINK $TOPIC_DIR "$HOME/.config" 

