#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

declare TOPIC_NAME="shell"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_depnedencies() {

	# insatll figlet
	install_packages figlet
	
	# install figlet fonts
	local -r FIGLET_FONTS_GITHUB_ORIGIN="https://github.com/xero/figlet-fonts.git"
	local -r FIGLET_FONTS_DIR="figlet-fonts"
	git clone $FIGLET_FONTS_GITHUB_ORIGIN $FIGLET_FONTS_DIR
	cp "$FIGLET_FONTS_DIR/*.flf" "/usr/share/figlet"
	rm -rf $FIGLET_FONTS_DIR

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	install_depnedencies
}

execute "main" "Setting up shell welcome screen ..."

