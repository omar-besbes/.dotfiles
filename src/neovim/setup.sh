#!/bin/bash

# source scripts
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

declare TOPIC_NAME="neovim"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

declare -r NEOVIM_BIN="nvim.appimage"
declare -r NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/$NEOVIM_BIN"

curl -LO $NEOVIM_APPIMAGE_URL
chmod u+x $NEOVIM_BIN
mv $NEOVIM_BIN /usr/local/bin

rm -rf "$HOME/.config/nvim"
ln -fs "$TOPIC_DIR/config" "$HOME/.config/nvim"

