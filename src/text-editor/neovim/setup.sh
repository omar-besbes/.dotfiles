#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="text-editor/neovim"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# only begin installation if one of the dependencies are not met
	cmd_exists nvim && return

	local -r NEOVIM_BIN="nvim-linux-x86_64.appimage"
	local -r NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/$NEOVIM_BIN"

	curl -fSLO $NEOVIM_APPIMAGE_URL
	chmod u+x $NEOVIM_BIN
	sudo mv $NEOVIM_BIN /usr/local/bin/nvim

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

create_symlinks() {

	local -r CONFIG_DIR="$HOME/.config"

	mkdir -p $CONFIG_DIR

	local -a FILES_TO_SYMLINK=("$TOPIC_DIR/nvim")
	local -a TARGET_PATHS=("$CONFIG_DIR/nvim")
	symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

	create_symlinks

}

execute "main" "Setting up neovim ..."
