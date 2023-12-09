#!/bin/bash

# source scripts
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"
source "$DOTFILES_SCRIPTS_DIR/symlink_files.sh"

declare TOPIC_NAME="shell"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# Install dependencies
install_packages figlet

# Setup bash files
declare -a FILES_TO_SYMLINK=(
	"bash_logout",
	"bash_profile",
	"bashrc",
	"inputrc",
)	
declare -r TARGET_DIR=$HOME

get_target_file() {
	echo ".$(printf "%s" "$1" | sed "s/.*\/\(.*\)/\1/g")"
}

symlink_files $FILES_TO_SYMLINK $TOPIC_DIR $TARGET_DIR get_target_file 

# Setup bash sub-topics
setup_topics $TOPIC_DIR

