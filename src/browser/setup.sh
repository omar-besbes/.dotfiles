#!/bin/bash

# ----------------------------------------------------------------------
# | Choose emulator                                                    |
# ----------------------------------------------------------------------

choose_browser() {
  source "$TOPIC_DIR/chromium/$TOPIC_SETUP_FILE"
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../..")"
  local TOPIC_NAME="browser"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  choose_browser

}
