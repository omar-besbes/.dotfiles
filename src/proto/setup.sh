#!/bin/bash

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../..")"
declare TOPIC_NAME="proto"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

	# only begin installation if one of the dependencies are not met
	cmd_exists proto && return

    # install proto
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes --no-profile
	
    # completions
	mkdir -p ~/.bash_completion.d
    proto completions > ~/.bash_completion.d/proto.sh

    # install packages
    proto install --config-mode global

}

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

    export PROTO_HOME="$HOME/.proto"
    export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"

    mkdir -p $PROTO_HOME

    local -a FILES_TO_SYMLINK=("$TOPIC_DIR/.prototools")
    local -a TARGET_PATHS=("$PROTO_HOME/.prototools")
    symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    ask_for_sudo

    create_symlinks

    install_dependencies

}

main
