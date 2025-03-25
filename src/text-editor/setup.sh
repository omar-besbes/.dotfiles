#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="text-editor"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"

# ----------------------------------------------------------------------
# | Setup text editors                                                 |
# ----------------------------------------------------------------------

setup_editors() {

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
