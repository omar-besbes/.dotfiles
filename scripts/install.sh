#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

mkdir -p "$DOTFILES_ROOT_DIR" || exit 1
cd "$DOTFILES_ROOT_DIR" || exit 1

source "$DOTFILES_ROOT_DIR/scripts/utils.sh"

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

	# install nvm
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
# | Install CLI                                                        |
# ----------------------------------------------------------------------

install_cli() {

  mkdir -p "$HOME/.local/bin"

  cat <<'EOF' > "$HOME/.local/bin/dotfiles"
#!/bin/bash
$HOME/.dotfiles/dotfiles.sh "$@"
EOF

  chmod +x "$HOME/.local/bin"

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

  install_cli

  print_info DONE

}

main
