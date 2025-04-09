#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="browser/brave"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# Add Brave's official GPG key:
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

	# Add the repository to Apt sources:
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
		https://brave-browser-apt-release.s3.brave.com/ stable main" |
		sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
	sudo apt-get update

	# Install package
	sudo apt-get install -y brave-browser

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

}

execute "main" "Setting up brave ..."
