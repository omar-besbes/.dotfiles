#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="kubectl"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Install new version                                                |
# ----------------------------------------------------------------------

install_dependencies() {

	cmd_exists kubectl && return

	# Add kubectl's official GPG key:
	sudo apt-get update
	sudo install -m 0755 -d /etc/apt/keyrings
	local -r VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt | cat | cut -f 1-2 -d '.')
	curl -fsSL "https://pkgs.k8s.io/core:/stable:/$VERSION/deb/Release.key" |
		sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

	# Add the repository to Apt sources:
	echo \
		"deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
		https://pkgs.k8s.io/core:/stable:/$VERSION/deb/ /" |
		sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update

	# Install packages
	sudo apt-get install -y kubectl

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

}
