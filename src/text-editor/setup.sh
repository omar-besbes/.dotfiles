#!/bin/bash

# ----------------------------------------------------------------------
# | Choose text editor                                                 |
# ----------------------------------------------------------------------

choose_editor() {

  source "$TOPIC_DIR/neovim/$TOPIC_SETUP_FILE"
  source "$TOPIC_DIR/vscode/$TOPIC_SETUP_FILE"
  # source "$TOPIC_DIR/vscodium/$TOPIC_SETUP_FILE"

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../..")"
  local TOPIC_NAME="text-editor"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  choose_editor

}
