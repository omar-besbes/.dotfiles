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

	local -r NEOVIM_BIN="nvim.appimage"
	local -r NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/$NEOVIM_BIN"

	curl -LO $NEOVIM_APPIMAGE_URL
	chmod u+x $NEOVIM_BIN
	sudo mv $NEOVIM_BIN /usr/local/bin

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

create_symlinks() {
	
	rm -rf "$HOME/.config/nvim"
	ln -fs "$TOPIC_DIR/config" "$HOME/.config/nvim"

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	install_dependencies
}

execute "main" "Setting up neovim ..."

