#!/bin/bash

# ----------------------------------------------------------------------
# | Choose text editor                                                 |
# ----------------------------------------------------------------------

setup_editors() {

  execute "source $TOPIC_DIR/neovim/$TOPIC_SETUP_FILE && main" "Setting up neovim ..."
  execute "source $TOPIC_DIR/vscode/$TOPIC_SETUP_FILE && main" "Setting up vscode ..."

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

  setup_editors

}
