#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

[ ! -v DOTFILES_ROOT_DIR ]	&& declare -r DOTFILES_ROOT_DIR="$HOME/.dotfiles"

cd	"$DOTFILES_ROOT_DIR" || exit 1

source "$DOTFILES_ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_ROOT_DIR/scripts/uninstall_topics.sh"

# ----------------------------------------------------------------------
# | Uninstall Global Dependencies                                      |
# ----------------------------------------------------------------------

uninstall_dependencies() {
	
	# uninstall curl
	execute "uninstall_packages curl" "Uninstalling curl ..."

	# uninstall rustup & cargo
	rustup self uninstall
	rm -rf "$HOME/.bash_completion.d/rustup"

	# uninstall nvm & node
	rm -rf "$NVM_DIR"

	# uninstall shellcheck
	execute "uninstall_packages shellcheck" "Installing shellcheck ..."

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	execute "sync_dotfiles" "Synchronizing files with remote ..."

	uninstall_dependencies

	# begin installing configs
	uninstall_topics $DOTFILES_SOURCE_DIR

}

main

