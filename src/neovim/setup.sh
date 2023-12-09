#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

declare TOPIC_NAME="neovim"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# install fuse to execute appimage files
	sudo add-apt-repository universe
	install_packages libfuse2 fuse

	local -r NEOVIM_BIN="nvim.appimage"
	local -r NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/$NEOVIM_BIN"

	curl -LO $NEOVIM_APPIMAGE_URL
	chmod u+x $NEOVIM_BIN
	sudo mv $NEOVIM_BIN /usr/local/bin/nvim

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

create_symlinks() {
	
	local -r NEOVIM_CONFIG_DIR="$HOME/.config/nvim"
	rm -rf $NEOVIM_CONFIG_DIR
	mkdir -p $NEOVIM_CONFIG_DIR
	ln -fsT "$TOPIC_DIR/config" $NEOVIM_CONFIG_DIR

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	
	install_dependencies

	create_symlinks

}

execute "main" "Setting up neovim ..."

