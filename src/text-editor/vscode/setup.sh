#!/bin/bash

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # only begin installation if one of the dependencies are not met
  cmd_exists code && return

  # Add VSCode's official GPG key:
  sudo apt-get update
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc |
    sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg

  # Add the repository to Apt sources:
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
    https://packages.microsoft.com/repos/code stable main" |
    sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  sudo apt-get update

  # Install packages
  sudo apt-get install -y code

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

  local -r VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
  mkdir -p $VSCODE_CONFIG_DIR

  local -a FILES_TO_SYMLINK=(
    "$TOPIC_DIR/keybindings.json"
    "$TOPIC_DIR/settings.json"
  )
  local -a TARGET_PATHS=(
    "$VSCODE_CONFIG_DIR/keybindings.json"
    "$VSCODE_CONFIG_DIR/settings.json"
  )
  symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../../..")"
  local TOPIC_NAME="text-editor/vscode"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  install_dependencies

  create_symlinks

}
