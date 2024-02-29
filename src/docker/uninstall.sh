#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="docker"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Uninstall previous versions                                        |
# ----------------------------------------------------------------------

uninstall() {

	for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; 
		do sudo apt-get remove $pkg; 
	done

	rm -rf "$HOME/.docker"

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	uninstall
}

