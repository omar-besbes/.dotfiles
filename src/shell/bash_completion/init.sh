#!/bin/bash

# source scripts
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/load_topics.sh"

declare TOPIC_NAME="shell/bash_completion"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# find bash completion files and source them one by one.
declare -r COMPLETION_FILES_DIR="$HOME/.bash_completion.d"
declare -r COMPLETION_FILES=$(find $COMPLETION_FILES_DIR -type f)
for i in ${COMPLETION_FILES[@]}; do
	source $i
done


