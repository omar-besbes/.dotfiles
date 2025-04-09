#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="fonts"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Nerd Fonts                                                         |
# ----------------------------------------------------------------------

install_nerd_fonts() {

	local -r FONT_DIR="$HOME/.local/share/fonts/truetype"
	local -r NERD_FONTS_GITHUB_ORIGIN="https://github.com/ryanoasis/nerd-fonts"
	local -a FONTS_TO_INSTALL=("Hack" "JetBrainsMono" "RobotoMono" "NerdFontsSymbolsOnly")

	# Ensure the font directory exists
	mkdir -p "$FONT_DIR"

	# Function to download and install a font
	install_font() {
		local font_name=$1
		if ! fc-list | grep -q "$font_name"; then
			curl -fSLJO# "$NERD_FONTS_GITHUB_ORIGIN/releases/latest/download/${font_name}.zip"
			unzip -qo "$font_name.zip" -d "$FONT_DIR/$font_name"
			rm -f "$font_name.zip"
		fi
	}

	# Download and install Nerd Fonts
	for i in ${FONTS_TO_INSTALL[@]}; do
		install_font "$i"
	done

	# Refresh the font cache
	fc-cache -fv

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	install_nerd_fonts
}
