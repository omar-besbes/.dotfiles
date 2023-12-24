#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="shell"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_depnedencies() {

	# only begin installation if one of the dependencies are not met
	cmd_exists figlet && return

	# insatll figlet
	install_packages figlet
	
	# install figlet fonts
	local -r FIGLET_FONTS_GITHUB_ORIGIN="https://github.com/xero/figlet-fonts.git"
	local -r FIGLET_FONTS_DIR="figlet-fonts"
	git clone $FIGLET_FONTS_GITHUB_ORIGIN $FIGLET_FONTS_DIR
	sudo cp "$FIGLET_FONTS_DIR"/*.flf "/usr/share/figlet"
	rm -rf $FIGLET_FONTS_DIR

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	
	ask_for_sudo

	install_depnedencies

}

execute "main" "Setting up shell welcome screen ..."

