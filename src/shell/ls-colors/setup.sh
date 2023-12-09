#!/bin/bash

# source scripts
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../../.."
source "$ROOT_DIR/scripts/utils.sh"

# Make sure to install the latest version of vivid, if vivid is not installed
declare -r VIVID_GITHUB_REPO="https://github.com/sharkdp/vivid"
declare -r VIVID_GITHUB_LATEST_RELEASE_URL="https://api.github.com/repos/sharkdp/vivid/releases/latest"
declare -r ARCH="amd64"
declare -r ASSET_EXTENSION=".deb"

download_vivid() {

	# Get the latest release information
	local -r RELEASE_INFO=$(curl -s $VIVID_GITHUB_LATEST_RELEASE_URL)

	# Extract the asset URL for the specified architecture and extension
	local -r ASSET_URL=$(echo "$RELEASE_INFO" | jq -r ".assets[] | select(.name | contains(\"$ARCH\") and contains(\"$ASSET_EXTENSION\")) | .browser_download_url")

	# Download the asset using curl
	if [ -n "$ASSET_URL" ]; then
		curl -LJO "$ASSET_URL"
	else
		print_error "No matching release asset found for $ARCH and $ASSET_EXTENSION. Please, download vivid manually from here: $VIVID_GITHUB_REPO."
	fi

}

if [ ! cmd_exists starship ]; then

	execute "download_vivid" "Downloading vivid ..."

fi

