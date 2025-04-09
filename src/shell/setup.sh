#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="shell"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

	local -a FILES_TO_SYMLINK=(
		"$TOPIC_DIR/bash_logout"
		"$TOPIC_DIR/bash_profile"
		"$TOPIC_DIR/bashrc"
		"$TOPIC_DIR/inputrc"
	)
	local -r TARGET_PATHS=(
		"$HOME/.bash_logout"
		"$HOME/.bash_profile"
		"$HOME/.bashrc"
		"$HOME/.inputrc"
	)
	symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	create_symlinks

	# Setup bash sub-topics
	setup_topics $TOPIC_DIR

  mkdir -p "$DOTFILES_BASH_COMPLETIONS_DIR"

}
