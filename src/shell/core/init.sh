#!/bin/bash

# source scripts
declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="shell/core"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/load_topics.sh"

# Add bash aliases, options & exports
source "$TOPIC_DIR/aliases.sh"
source "$TOPIC_DIR/default.sh"
source "$TOPIC_DIR/env.sh"
source "$TOPIC_DIR/options.sh"
