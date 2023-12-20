#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

DIR=$(dirname "${BASH_SOURCE[0]}")
ROOT_DIR=$DIR
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"
source "$DOTFILES_SCRIPTS_DIR/sync_files.sh"

cd $DOTFILES_ROOT_DIR

# ----------------------------------------------------------------------
# | Fonts                                                              |
# ----------------------------------------------------------------------

install_fonts() {
	
	local -r FONT_DIR="$HOME/.local/share/fonts/truetype"
	local -r NERD_FONTS_GITHUB_ORIGIN="https://github.com/ryanoasis/nerd-fonts"
	local -r NERD_FONTS_LATEST_RELEASE_URL="https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"
	
	# Ensure the font directory exists
	mkdir -p ${FONT_DIR}
	
	# Get the latest version from GitHub releases
	local -r LATEST_VERSION=$(curl -s $NERD_FONTS_LATEST_RELEASE_URL | grep -oP '"tag_name": "\K(.*)(?=")')

	# Function to download and install a font
	install_font() {
		local font_name=$1
		wget -q "${NERD_FONTS_GITHUB_ORIGIN}/releases/download/${LATEST_VERSION}/${font_name}.zip" -P ${FONT_DIR}
		unzip -q "${FONT_DIR}/${font_name}.zip" -d ${FONT_DIR}
		rm -f "${FONT_DIR}/${font_name}.zip"
	}

	# Download and install Nerd Fonts
	install_font Hack
	install_font JetBrainsMono
	install_font RobotoMono

	# Refresh the font cache
	fc-cache -fv

}

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# install curl
	execute "install_packages curl" "Installing curl ..."

	# install rustup & cargo
	execute "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y" "Installing rustup ..."
	source "$HOME/.cargo/env"
	mkdir -p "$HOME/.bash_completion.d"
	rustup completions bash > "$HOME/.bash_completion.d/rustup"

	# install nvm & node
	execute "PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'" "Installing nvm ..."

	# install gcc, g++ & some other tools
	execute "install_packages build-essential software-properties-common" "Installing essential tools ..."

	# install shellcheck
	execute "install_packages shellcheck" "Installing shellcheck ..."

	# install xclip
	execute "install_packages xclip" "Installing xclip ..."

	# isntall necessary compression and extraction tools
	execute "install_packages bzip2 gzip zip xz-utils tar" "Installing extraction/compression tools ..."

	# install fonts utils
	execute "install_packages fontconfig" "Installing font utilities ..."

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

	execute "install_fonts" "Installing fonts ..."

	execute "sync_dotfiles" "Synchronizing files with remote ..."

	# begin installing configs
	setup_topics $DOTFILES_SOURCE_DIR

	# update current terminal session 
	source "$HOME/.bashrc"

}

main

