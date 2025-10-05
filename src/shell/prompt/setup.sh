#!/bin/bash

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # only begin installation if one of the dependencies are not met
  cmd_exists starship && return

  # Make sure to install the latest version of starship, if starship is not installed
  local -r STARHIP_INSTALL_SCRIPT_URL="https://starship.rs/install.sh"
  curl -fsSL $STARHIP_INSTALL_SCRIPT_URL | sh -s -- -y

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

  local -a FILES_TO_SYMLINK=("$TOPIC_DIR/starship.toml")
  local -a TARGET_PATHS=("$HOME/.config/starship.toml")
  symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../../..")"
  local TOPIC_NAME="shell/prompt"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  install_dependencies

  create_symlinks

}

execute "main" "Setting up shell prompt ..."
