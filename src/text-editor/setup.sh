#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="text-editor"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Choose text editor                                                 |
# ----------------------------------------------------------------------

choose_editor() {

	bash -c "source $TOPIC_DIR/neovim/$TOPIC_SETUP_FILE"
	bash -c "source $TOPIC_DIR/vscode/$TOPIC_SETUP_FILE"
	# bash -c "source $TOPIC_DIR/vscodium/$TOPIC_SETUP_FILE"

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	choose_editor
}
