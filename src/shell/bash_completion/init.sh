#!/bin/bash

# source scripts
declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="shell/bash_completion"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/load_topics.sh"

# find bash completion files and source them one by one.
declare -r COMPLETION_FILES=$(find $DOTFILES_BASH_COMPLETIONS_DIR -type f)
for i in ${COMPLETION_FILES[@]}; do
	source $i
done
