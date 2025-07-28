#!/bin/bash

# ----------------------------------------------------------------------
# | Install new version                                                |
# ----------------------------------------------------------------------

install_dependencies() {

  cmd_exists docker && return

  local -r codename="$(. /etc/os-release && echo "$VERSION_CODENAME")"
  local -r id="$(. /etc/os-release && echo "$ID")"

  # Add Docker's official GPG key:
  sudo apt-get update
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL "https://download.docker.com/linux/$id/gpg" -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
		https://download.docker.com/linux/$id $codename stable" |
    sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt-get update

  # Install packages
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  if ! is_ci; then
    # Setup rootless docker mode
    sudo groupadd -f docker
    sudo usermod -aG docker $(whoami)
    newgrp docker

    # Configure docker to start on boot
    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service
  fi

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../..")"
  local TOPIC_NAME="docker"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  install_dependencies

}
