#!/bin/bash

# source scripts
ROOT_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$ROOT_DIR/scripts/utils.sh"
source "$DOTFILES_SCRIPTS_DIR/setup_topics.sh"

cd $DOTFILES_ROOT_DIR

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

 	execute "setup_topics $DOTFILES_SOURCE_DIR"

}

main
