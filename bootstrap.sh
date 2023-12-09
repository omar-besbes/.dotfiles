#!/bin/bash

# source scripts
ROOT_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"

cd $DOTFILES_ROOT_DIR

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# install curl
	execute "install_packages curl" "Installing curl ..."

	# install rustup & cargo
	execute "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" "Installing rustup ..."

	# install nvm & node
	execute "PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'" "Installing nvm ..."

	# install gcc, g++ & some other tools
	execute "install_packages build-essential" "Installing essential tools ..."

	# install shellcheck
	execute "install_packages shellcheck" "Installing shecllcheck ..."

	# install xclip
	execute "install_packages xclip" "Installing xclip ..."

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	install_dependencies

	# begin installing configs
	setup_topics $DOTFILES_SOURCE_DIR

	# update current terminal session 
	source "$HOME/.bashrc"

}

main
