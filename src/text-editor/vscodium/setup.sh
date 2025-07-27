#!/bin/bash

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # only begin installation if one of the dependencies are not met
  cmd_exists codium && return

  # Add VSCodium's official GPG key:
  curl -sS https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg |
    sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg

  # Add the repository to Apt sources:
  echo \
    "deb [ signed-by=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg ] \
		https://download.vscodium.com/debs vscodium main" |
    sudo tee /etc/apt/sources.list.d/vscodium.list
  sudo apt-get update

  # Install packages
  sudo apt-get install -y codium

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {


  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../../..")"
  local TOPIC_NAME="text-editor/vscodium"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  install_dependencies

}
