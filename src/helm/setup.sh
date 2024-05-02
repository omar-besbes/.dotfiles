#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="helm"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Install new version                                                |
# ----------------------------------------------------------------------

install_dependencies() {

    cmd_exists helm && return

    # Add kubectl's official GPG key:
    curl https://baltocdn.com/helm/signing.asc |
        sudo gpg --dearmor -o /usr/share/keyrings/helm.gpg
    sudo apt-get install apt-transport-https --yes

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] \
        https://baltocdn.com/helm/stable/debian/ all main" |
        sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update

    # Install packages
    sudo apt-get install -y helm

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    ask_for_sudo

    install_dependencies

}
