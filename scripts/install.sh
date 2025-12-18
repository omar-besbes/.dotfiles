#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

[ ! -v DOTFILES_ROOT_DIR ] && source "$HOME/.dotfiles/scripts/utils.sh"
cd "$DOTFILES_ROOT_DIR" || exit 1

# ----------------------------------------------------------------------
# | Global Dependencies                                                |
# ----------------------------------------------------------------------

install_dependencies() {

  # update dependencies list
  execute "sudo apt-get update" "Updating ..."

	# install git
	execute "sudo apt-get install -y git" "Installing git ..."

	# install curl
	execute "sudo apt-get install -y curl" "Installing curl ..."

  # install gum
  if ! cmd_exists gum; then
    sudo install -m 0755 -d /etc/apt/keyrings
    execute '
      curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/charm.gpg
      echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
      sudo apt-get update
      sudo apt-get install -y gum
    ' "Installing gum ..."
  fi

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
		source "$HOME/.deno/env"
		deno completions bash >"$DOTFILES_BASH_COMPLETIONS_DIR/deno.sh"
	fi

	# install go
	if ! cmd_exists go; then
		GO_VERSION="1.25.5"
		execute "
		  curl -fsSL https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz -o go.linux-amd64.tar.gz &&
			sudo rm -rf /usr/local/go &&
			sudo tar -C /usr/local -xzf go.linux-amd64.tar.gz &&
			rm go.linux-amd64.tar.gz
		" "Installing go ..."
	fi

	# install shellcheck
	execute "sudo apt-get install -y shellcheck" "Installing shellcheck ..."

	# install xclip
	execute "sudo apt-get install -y xclip" "Installing xclip ..."

	# install gcc, g++ & some other tools
	execute "sudo apt-get install -y ca-certificates fontconfig build-essential" "Installing essential tools ..."

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

  chmod +x $HOME/.local/bin/*

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
