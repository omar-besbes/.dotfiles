#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="spotify"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Install new version                                                |
# ----------------------------------------------------------------------

install_dependencies() {

    cmd_exists spotify-client && return

    # TO BE UPDATED BEFORE 6 Feb 2026
    KEY_URL="https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg"

    # Add Spotify's official GPG key:
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg |
        sudo gpg --dearmor --yes -o /etc/apt/keyrings/spotify.gpg

    # Add the repository to Apt sources:
    echo \
        "deb [signed-by=/etc/apt/keyrings/spotify.gpg] \
        http://repository.spotify.com stable non-free" |
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
