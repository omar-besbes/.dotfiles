#!/bin/bash

# ----------------------------------------------------------------------
# | Choose emulator                                                    |
# ----------------------------------------------------------------------

choose_emulator() {
  execute "source $TOPIC_DIR/alacritty/$TOPIC_SETUP_FILE && main" "Setting up alacritty ..."
}

# ----------------------------------------------------------------------
# | Set default terminal emulator                                      |
# ----------------------------------------------------------------------

set_default_terminal_emulator() {

  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
  sudo update-alternatives --auto x-terminal-emulator

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../..")"
  local TOPIC_NAME="terminal-emulator"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  choose_emulator

  set_default_terminal_emulator

}
