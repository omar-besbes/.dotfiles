#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

#
# WARNING
# =======
#
# This section was written in this way to make sure that it can be run 
# remotely or locally with the same behaviour.
#
# Please do not change anything here unless you know very well well
# what you are doing.
#
# =======
#

[ ! -v DOTFILES_ROOT_DIR ]	&& declare -r DOTFILES_ROOT_DIR="$HOME/.dotfiles"

mkdir -p "$DOTFILES_ROOT_DIR"
cd	"$DOTFILES_ROOT_DIR" || exit 1

declare -r CURRENT_BRANCH=$(git branch --show-current 2> /dev/null || echo "main")
declare -r DOTFILES_GITHUB_RAW_CONTENT_ORIGIN="https://raw.githubusercontent.com/omar-besbes/.dotfiles/$CURRENT_BRANCH"

source "$DOTFILES_ROOT_DIR/scripts/utils.sh"				&> /dev/null \
	|| source <(curl -s "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/utils.sh")
source "$DOTFILES_ROOT_DIR/scripts/setup_topics.sh"	&> /dev/null \
	|| source <(curl -s "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/setup_topics.sh")
source "$DOTFILES_ROOT_DIR/scripts/sync_files.sh"		&> /dev/null \
	|| source <(curl -s "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/sync_files.sh")

# ----------------------------------------------------------------------
# | Fonts                                                              |
# ----------------------------------------------------------------------

install_fonts() {
	
	local -r FONT_DIR="$HOME/.local/share/fonts/truetype"
	local -r NERD_FONTS_GITHUB_ORIGIN="https://github.com/ryanoasis/nerd-fonts"
	local -r NERD_FONTS_LATEST_RELEASE_URL="https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest"
	local -a FONTS_TO_INSTALL=("Hack" "JetBrainsMono" "RobotoMono")
	
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
	for i in ${FONTS_TO_INSTALL[@]}; do
		install_font i
	done

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
	if [ ! $(cmd_exists rustup) ]; then
		execute "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y" "Installing rustup ..."
		source "$HOME/.cargo/env"
		mkdir -p "$HOME/.bash_completion.d"
		rustup completions bash > "$HOME/.bash_completion.d/rustup"
	fi

	# install nvm & node
	[ ! $(cmd_exists nvm) ] && \
		execute "PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'" "Installing nvm ..."

	# install shellcheck
	execute "install_packages shellcheck" "Installing shellcheck ..."

	# install xclip
	execute "install_packages xclip" "Installing xclip ..."

	# isntall necessary compression and extraction tools
	execute "install_packages bzip2 gzip zip xz-utils tar" "Installing extraction/compression tools ..."

	# install gcc, g++ & some other tools
	execute "install_packages fontconfig build-essential software-properties-common" "Installing essential tools ..."

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	execute "install_packages git" "Installing git ..."

	sync_dotfiles
	#execute "sync_dotfiles" "Synchronizing files with remote ..."

	install_dependencies

	execute "install_fonts" "Installing fonts ..."

	# begin installing configs
	setup_topics $DOTFILES_SOURCE_DIR

}

main

