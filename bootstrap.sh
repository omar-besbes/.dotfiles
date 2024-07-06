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
# Please do not change anything here unless you know very well
# what you are doing.
#
# =======
#

[ ! -v DOTFILES_ROOT_DIR ] && declare -r DOTFILES_ROOT_DIR="$HOME/.dotfiles"

mkdir -p "$DOTFILES_ROOT_DIR"
cd "$DOTFILES_ROOT_DIR" || exit 1

[ ! -v CURRENT_BRANCH ] \
	&& declare -r CURRENT_BRANCH=$(git branch --show-current 2> /dev/null || echo "main")
[ ! -v DOTFILES_GITHUB_RAW_CONTENT_ORIGIN ] \
	&& declare -r DOTFILES_GITHUB_RAW_CONTENT_ORIGIN="https://raw.githubusercontent.com/omar-besbes/.dotfiles/$CURRENT_BRANCH"

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

	# install proto
	execute "cmd_exists proto || (curl -fsSL https://moonrepo.dev/install/proto.sh | bash --yes --no-profile)" "Installing proto ..."
	execute	"proto completions > ~/.bash_completion.d/proto.sh" "Proto completions ..."

	# install runtimes
	execute "proto install node lts" 		"Installing node ..."
	execute "proto install rust stable"		"Installing rust ..."
	execute "proto install go latest"		"Installing go ..."
	execute "proto install python latest"	"Installing python ..."

	# install shellcheck
	execute "sudo apt-get install -y shellcheck" "Installing shellcheck ..."

	# install xclip
	execute "sudo apt-get install -y xclip" "Installing xclip ..."

	# isntall necessary compression and extraction tools
	execute "sudo apt-get install -y bzip2 gzip zip xz-utils tar" "Installing extraction/compression tools ..."

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
