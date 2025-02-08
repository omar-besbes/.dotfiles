#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="browser/opera"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# Add Opera's official GPG key:
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://deb.opera.com/archive.key |
		gpg --dearmor -o /usr/share/keyrings/opera-browser.gpg

	# Add the repository to Apt sources:
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/opera-browser.gpg] \
		http://deb.opera.com/opera/ stable non-free" |
		sudo tee /etc/apt/sources.list.d/opera-archive.list >/dev/null
	sudo apt-get update

	# Install package
	sudo apt-get install -y opera-stable

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

}

execute "main" "Setting up brave ..."
