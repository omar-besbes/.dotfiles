#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="shell"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

	local -a FILES_TO_SYMLINK=(
		"bash_logout"
		"bash_profile"
		"bashrc"
		"inputrc"
	)	
	local -r TARGET_DIR=$HOME

	get_target_file() {
		echo ".$(printf "%s" "$1" | sed "s/.*\/\(.*\)/\1/g")"
	}

	symlink_files FILES_TO_SYMLINK[@] $TOPIC_DIR $TARGET_DIR get_target_file 

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	create_symlinks

	# Setup bash sub-topics
	setup_topics $TOPIC_DIR

}

