#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="terminal-emulator"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

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
