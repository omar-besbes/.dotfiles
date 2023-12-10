#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="$(realpath "$DIR/../../..")"
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

declare TOPIC_NAME="shell/prompt"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# Make sure to install the latest version of starship, if starship is not installed
	local -r STARHIP_INSTALL_SCRIPT_URL="https://starship.rs/install.sh"
	[ ! cmd_exists starship ] && curl -sS $STARHIP_INSTALL_SCRIPT_URL | sh

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

	local -a FILES_TO_SYMLINK=(
		"starship.toml",
	)	
	local -r TARGET_DIR="$HOME/.config"

	symlink_files FILES_TO_SYMLINK[@] $TOPIC_DIR $TOPIC_DIR

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	install_dependencies

	create_symlinks

}

execute "main" "Setting up shell prompt ..."

