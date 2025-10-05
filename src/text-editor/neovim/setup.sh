#!/bin/bash

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # only begin installation if one of the dependencies are not met
  cmd_exists nvim && return

  local -r NEOVIM_BIN="nvim-linux-x86_64.appimage"
  local -r NEOVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/$NEOVIM_BIN"

  curl -fSLO $NEOVIM_APPIMAGE_URL
  chmod u+x $NEOVIM_BIN
  sudo mv $NEOVIM_BIN /usr/local/bin/nvim

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

  local -r CONFIG_DIR="$HOME/.config"

  mkdir -p $CONFIG_DIR

  local -a FILES_TO_SYMLINK=("$TOPIC_DIR/nvim")
  local -a TARGET_PATHS=("$CONFIG_DIR/nvim")
  symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../../..")"
  local TOPIC_NAME="text-editor/neovim"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  install_dependencies

  create_symlinks

}
