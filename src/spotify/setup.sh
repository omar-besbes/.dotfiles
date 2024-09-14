#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="spotify"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Install new version                                                |
# ----------------------------------------------------------------------

install_dependencies() {

    cmd_exists spotify-client && return

    # Add Spotify's official GPG key:
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | 
        sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg

    # Add the repository to Apt sources:
    echo "deb http://repository.spotify.com stable non-free" | 
        sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update

    # Install packages
    sudo apt-get install -y spotify-client

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    ask_for_sudo

    install_dependencies

}
