#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="git"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

	local -a FILES_TO_SYMLINK=("$TOPIC_DIR/gitconfig")
	local -r TARGET_PATHS=("$HOME/.gitconfig")
	symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	create_symlinks

}
