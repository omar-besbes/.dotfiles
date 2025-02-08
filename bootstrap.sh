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

[ ! -v DOTFILES_ROOT_DIR ] && declare -r DOTFILES_ROOT_DIR="$HOME/.dotfiles"

mkdir -p "$DOTFILES_ROOT_DIR"
mkdir -p "$DOTFILES_BASH_COMPLETIONS_DIR"
cd "$DOTFILES_ROOT_DIR" || exit 1

[ ! -v CURRENT_BRANCH ] &&
	declare -r CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
[ ! -v DOTFILES_GITHUB_RAW_CONTENT_ORIGIN ] &&
	declare -r DOTFILES_GITHUB_RAW_CONTENT_ORIGIN="https://raw.githubusercontent.com/omar-besbes/.dotfiles/$CURRENT_BRANCH"

source "$DOTFILES_ROOT_DIR/scripts/utils.sh" &>/dev/null ||
	source <(curl -fsSL "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/utils.sh")
source "$DOTFILES_ROOT_DIR/scripts/setup_topics.sh" &>/dev/null ||
	source <(curl -fsSL "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/setup_topics.sh")
source "$DOTFILES_ROOT_DIR/scripts/sync_files.sh" &>/dev/null ||
	source <(curl -fsSL "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/sync_files.sh")

# ----------------------------------------------------------------------
# | Global Dependencies                                                |
# ----------------------------------------------------------------------

install_dependencies() {

	# install git
	execute "sudo apt-get install -y git" "Installing git ..."

	# install curl
	execute "sudo apt-get install -y curl" "Installing curl ..."

	# isntall necessary compression and extraction tools
	execute "sudo apt-get install -y bzip2 gzip zip xz-utils tar" "Installing extraction/compression tools ..."

	# install rustup & cargo
	if ! cmd_exists rustup; then
		execute "curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- --no-modify-path -y" "Installing rustup ..."
		source "$HOME/.cargo/env"
		rustup completions bash >"$DOTFILES_BASH_COMPLETIONS_DIR/rustup.sh"
		rustup completions bash cargo >"$DOTFILES_BASH_COMPLETIONS_DIR/cargo.sh"
	fi

	# install deno
	if ! cmd_exists deno; then
		execute "curl -fsSL https://deno.land/install.sh | sh -s -- --no-modify-path -y" "Installing deno ..."
		deno completions bash >"$DOTFILES_BASH_COMPLETIONS_DIR/deno.sh"
	fi

	# install nvm & node
	! cmd_exists nvm &&
		execute "PROFILE=/dev/null bash -c 'curl -fSL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'" "Installing nvm ..."

	# install shellcheck
	execute "sudo apt-get install -y shellcheck" "Installing shellcheck ..."

	# install xclip
	execute "sudo apt-get install -y xclip" "Installing xclip ..."

	# install gcc, g++ & some other tools
	execute "sudo apt-get install -y ca-certificates fontconfig build-essential software-properties-common" "Installing essential tools ..."

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

	execute "sync_dotfiles" "Synchronizing files with remote ..."

	# begin installing configs
	setup_topics $DOTFILES_SOURCE_DIR

}

main
