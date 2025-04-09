#!/bin/bash

# source scripts
declare DIR="$(dirname "${BASH_SOURCE[0]}")"
declare ROOT_DIR="$(realpath "$DIR/../../..")"
declare TOPIC_NAME="shell/core"
declare TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

[ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

# Add bash aliases, options & exports
source "$TOPIC_DIR/aliases.sh"
source "$TOPIC_DIR/default.sh"
source "$TOPIC_DIR/env.sh"
source "$TOPIC_DIR/options.sh"
