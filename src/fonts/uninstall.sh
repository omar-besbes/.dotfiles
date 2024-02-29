#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="fonts"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Nerd Fonts                                                         |
# ----------------------------------------------------------------------

uninstall_nerd_fonts() {
	
	local -r FONT_DIR="$HOME/.local/share/fonts/truetype"
	local -a FONTS_TO_UNINSTALL=("Hack" "JetBrainsMono" "RobotoMono" "NerdFontsSymbolsOnly")
	
	# Ensure the font directory exists
	mkdir -p "$FONT_DIR"

	# Function to uninstall a font
	uninstall_font() {
		local font_name=$1
		if fc-list | grep -q "$font_name"; then
			rm -rf "$FONT_DIR/$font_name"
		fi
	}

	# Uninstall Nerd Fonts
	for i in ${FONTS_TO_UNINSTALL[@]}; do
		uninstall_font "$i"
	done

	# Refresh the font cache
	fc-cache -fv

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	uninstall_nerd_fonts
}

