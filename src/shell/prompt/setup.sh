#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="shell/prompt"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# only begin installation if one of the dependencies are not met
	cmd_exists starship && return

	# Make sure to install the latest version of starship, if starship is not installed
	local -r STARHIP_INSTALL_SCRIPT_URL="https://starship.rs/install.sh"
	curl -sS $STARHIP_INSTALL_SCRIPT_URL | sh -s -- -y

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

	local -a FILES_TO_SYMLINK=(
		"starship.toml"
	)	
	local -r TARGET_DIR="$HOME/.config"

	symlink_files FILES_TO_SYMLINK[@] $TOPIC_DIR $TARGET_DIR

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

	create_symlinks

}

execute "main" "Setting up shell prompt ..."

