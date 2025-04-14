#!/bin/bash

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # only begin installation if one of the dependencies are not met
  cmd_exists vivid && return

  local -r VIVID_GITHUB_REPO="https://github.com/sharkdp/vivid"
  local -r VIVID_GITHUB_LATEST_RELEASE_URL="https://api.github.com/repos/sharkdp/vivid/releases/latest"

  # make sure curl & jq are installed
  sudo apt-get install -y curl jq

  # Get the latest release information
  local -r RELEASE_INFO=$(curl -fsSL $VIVID_GITHUB_LATEST_RELEASE_URL)

  # Extract the asset URL for the specified architecture and extension
  local -r ASSET_URL=$(echo "$RELEASE_INFO" | jq -r ".assets[] | select(.name | contains(\"$ARCH\") and contains(\"$ASSET_EXTENSION\") and (contains(\"musl\") | not)) | .browser_download_url")
  local -r VIVID_BIN=$(basename $ASSET_URL)

  # Download the asset using curl and install it
  if [ -n "$ASSET_URL" ]; then
    curl -fSLJO "$ASSET_URL"
    sudo apt-get install -y "./$VIVID_BIN"
    rm "$VIVID_BIN"
  else
    print_error "No matching release asset found for $ARCH and $ASSET_EXTENSION. Please, download vivid manually from here: $VIVID_GITHUB_REPO."
  fi

}

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../../..")"
  local TOPIC_NAME="shell/ls-colors"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo

  # Make sure to install the latest version of vivid, if vivid is not installed
  install_dependencies

}

execute "main" "Setting up shell colors ..."
