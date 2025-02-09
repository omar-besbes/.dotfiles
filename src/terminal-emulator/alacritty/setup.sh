#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="terminal-emulator/alacritty"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# only begin installation if one of the dependencies are not met
	cmd_exists alacritty && return

	# install alacritty
	local -r ALACRITTY_GITHUB_ORIGIN="https://github.com/alacritty/alacritty.git"
	local -r ALACRITTY_DIR="alacritty"
	git clone $ALACRITTY_GITHUB_ORIGIN $ALACRITTY_DIR
	cd $ALACRITTY_DIR
	sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	cargo build --release

	# verify if alacirtty is well installed
	if [ -v infocmp alacritty ]; then
		sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
	fi

	# desktop entry
	sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
	sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
	sudo desktop-file-install extra/linux/Alacritty.desktop
	sudo update-desktop-database

	# man pages
	sudo apt-get install -y gzip scdoc
	sudo mkdir -p /usr/local/share/man/man1
	sudo mkdir -p /usr/local/share/man/man5
	scdoc <extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz >/dev/null
	scdoc <extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz >/dev/null
	scdoc <extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz >/dev/null
	scdoc <extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz >/dev/null

	# completions
	cp -f extra/completions/alacritty.bash "$DOTFILES_BASH_COMPLETIONS_DIR/alacritty.sh"

	# install alacritty themes
	local -r ALACRITTY_THEMES_DIR="$HOME/.config/alacritty/themes"
	local -r ALACRITTY_THEMES_GITHUB_ORIGIN="https://github.com/alacritty/alacritty-theme"
	mkdir -p $ALACRITTY_THEMES_DIR
	git clone $ALACRITTY_THEMES_GITHUB_ORIGIN $ALACRITTY_TEHMES_DIR

	# clean up
	cd -
	rm -rf $ALACRITTY_DIR

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

	local -a FILES_TO_SYMLINK=("$TOPIC_DIR/alacritty.yml")
	local -a TARGET_PATHS=("$HOME/.config/alacritty/alacritty.yml")
	symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	ask_for_sudo

	install_dependencies

	create_symlinks

}

execute "main" "Setting up alacritty ..."
