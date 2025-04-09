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
# Please do not change anything here unless you know very very well
# what you are doing.
#
# =======
#

set -eo pipefail

# Check if git is installed
if ! command -v git &>/dev/null; then
  echo "Git is not installed. Please install Git to proceed."
  exit 1
fi

# Check if curl is installed
if ! command -v curl &>/dev/null; then
  echo "Curl is not installed. Please install Curl to proceed."
  exit 1
fi

[ ! -v CURRENT_BRANCH ] &&
	declare -r CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
[ ! -v DOTFILES_GITHUB_RAW_CONTENT_ORIGIN ] &&
	declare -r DOTFILES_GITHUB_RAW_CONTENT_ORIGIN="https://raw.githubusercontent.com/omar-besbes/.dotfiles/$CURRENT_BRANCH"

source "$DOTFILES_ROOT_DIR/scripts/utils.sh" &>/dev/null ||
	source <(curl -fsSL "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/utils.sh")

# ----------------------------------------------------------------------
# | Usage                                                              |
# ----------------------------------------------------------------------

usage() {
  cat <<EOF
Usage: dotfiles.sh <command>

Commands:
  install      Run all setup.sh scripts
  backup       Run all backup.sh scripts
  restore      Run all restore.sh scripts
  test         Run test suite in containers
  help         Show this message
EOF
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

case "${1:-}" in
  install)
    bash scripts/install.sh

    ;;
  backup)
    bash scripts/backup.sh
    ;;
  restore)
    bash scripts/restore.sh
    ;;
  test)
    bash test/test.sh
    ;;
  '-h' | 'help' | '--help')
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
