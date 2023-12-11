#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="$(realpath "$DIR/../..")"
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"

declare TOPIC_NAME="terminal-emulator"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# ----------------------------------------------------------------------
# | Choose emulator                                                    |
# ----------------------------------------------------------------------

choose_emulator() {
	source "$TOPIC_DIR/alacritty/$TOPIC_SETUP_FILE"
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	choose_emulator
}

execute "main" "Setting up terminal emulator ..."

