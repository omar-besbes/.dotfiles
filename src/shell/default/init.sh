#!/bin/bash

# source scripts
ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/../../.."
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/load_topics.sh"

declare TOPIC_NAME="shell/default"
declare TOPIC_DIR="$DOTFILES_SOURCE_DIR/$TOPIC_NAME"

# Add bash aliases, options & exports
source "$TOPIC_DIR/aliases.sh"
source "$TOPIC_DIR/default.sh"
source "$TOPIC_DIR/env.sh"
source "$TOPIC_DIR/options.sh"

