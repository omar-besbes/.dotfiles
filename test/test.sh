#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR=$(dirname "${BASH_SOURCE[0]}")
declare ROOT_DIR="$(realpath "$DIR/..")"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# ----------------------------------------------------------------------
# | Check Commands                                                     |
# ----------------------------------------------------------------------

declare -a COMMANDS_TO_VERIFY=(
	"nvim"
	"starship"
	"vivid"
	"alacritty"
	"git"
	"docker"
	"kubectl"
	"chromium"
	"code"
	"spotify"
  "deno"
  "rustup"
  "cargo"
)

check_commands_existence() {

	local commands=("$@")
	local missing_commands=()

	for cmd in "${commands[@]}"; do
		if ! cmd_exists "$cmd"; then
			missing_commands+=("$cmd")
		fi
	done

	if [ ${#missing_commands[@]} -gt 0 ]; then
		print_error "The following commands were not installed: ${missing_commands[*]}"
		exit 1
	else
		print_success "All commands are installed"
	fi

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {
	check_commands_existence "${COMMANDS_TO_VERIFY[@]}"
}

main
