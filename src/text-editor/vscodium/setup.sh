#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="text-editor/vscodium"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

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

  ask_for_sudo

  install_dependencies

}

execute "main" "Setting up vscodium ..."
