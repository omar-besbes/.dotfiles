#!/bin/bash

# ----------------------------------------------------------------------
# | Install new version                                                |
# ----------------------------------------------------------------------

install_dependencies() {

  cmd_exists helm && return

  sudo apt-get install apt-transport-https --yes

  # Add kubectl's official GPG key:
  curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey |
    sudo gpg --dearmor -o /etc/apt/keyrings/helm.gpg

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/helm.gpg] \
        https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" |
    sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get update

  # Install packages
  sudo apt-get install -y helm

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../..")"
  local TOPIC_NAME="helm"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  install_dependencies

}
