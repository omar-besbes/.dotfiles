#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="neovim"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# only begin installation if one of the dependencies are not met
	cmd_exists nvim && return

	# install fuse to execute appimage files
	sudo add-apt-repository universe
	install_packages libfuse2 fuse

	local -r NEOVIM_BIN="nvim.appimage"
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
	local -r NEOVIM_CONFIG_DIR="$CONFIG_DIR/nvim"
	rm -rf $NEOVIM_CONFIG_DIR
	mkdir -p $CONFIG_DIR
	ln -fs "$TOPIC_DIR/nvim" $CONFIG_DIR

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo
	
	install_dependencies

	create_symlinks

}

