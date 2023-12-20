#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"

source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	local -r VIVID_GITHUB_REPO="https://github.com/sharkdp/vivid"
	local -r VIVID_GITHUB_LATEST_RELEASE_URL="https://api.github.com/repos/sharkdp/vivid/releases/latest"
	
	# make sure curl & jq are installed
	install_packages curl jq

	# Get the latest release information
	local -r RELEASE_INFO=$(curl -s $VIVID_GITHUB_LATEST_RELEASE_URL)

	# Extract the asset URL for the specified architecture and extension
	local -r ASSET_URL=$(echo "$RELEASE_INFO" | jq -r ".assets[] | select(.name | contains(\"$ARCH\") and contains(\"$ASSET_EXTENSION\") and (contains(\"musl\") | not)) | .browser_download_url")
	local -r VIVID_BIN=$(basename $ASSET_URL)

	# Download the asset using curl and install it
	if [ -n "$ASSET_URL" ]; then
		curl -LJO $ASSET_URL
		install_packages $VIVID_BIN
		rm $VIVID_BIN
	else
		print_error "No matching release asset found for $ARCH and $ASSET_EXTENSION. Please, download vivid manually from here: $VIVID_GITHUB_REPO."
	fi

}

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	# Make sure to install the latest version of vivid, if vivid is not installed
	[ ! $(cmd_exists vivid) ] && install_dependencies

}

execute "main" "Setting up shell colors ..."

