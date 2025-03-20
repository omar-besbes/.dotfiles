#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="text-editor/vscode"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

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
# | Post Install                                                       |
# ----------------------------------------------------------------------

post_install() {
  code --install-extension github.github-vscode-theme
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  ask_for_sudo

  install_dependencies

  create_symlinks

  post_install

}

execute "main" "Setting up vscode ..."
