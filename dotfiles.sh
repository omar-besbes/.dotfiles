#!/bin/bash
set -euo pipefail

#
# WARNING
# =======
#
# This script was written in this way to make sure that it can be run
# remotely or locally with the same behaviour.
#
# Please do not change anything here unless you know very very well
# what you are doing.
#
# =======
#

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
  iso          Build ISO via GitHub Actions
  help         Show this message
EOF
}

# ----------------------------------------------------------------------
# | Run Command                                                        |
# ----------------------------------------------------------------------

run_command() {

  case "${1:-}" in
    install)
      (source_or_fetch scripts/install.sh)
      ;;
    backup)
      (source_or_fetch scripts/backup.sh)
      ;;
    restore)
      (source_or_fetch scripts/restore.sh)
      ;;
    test)
      (source_or_fetch test/test.sh)
      ;;
    iso)
      (source_or_fetch scripts/iso.sh)
      ;;
    interactive)
      if command -v gum &>/dev/null; then
        run_command $(gum choose "install" "backup" "restore" "test" "iso")
      else
        usage
        exit 1
      fi
      ;;
    *)
      usage
      exit 1
      ;;
  esac

}

# ----------------------------------------------------------------------
# | Source or Fetch                                                    |
# ----------------------------------------------------------------------

source_or_fetch() {
  local path="${1?}"
  if [ -f "$DOTFILES_ROOT_DIR/$path" ]; then
    source "$DOTFILES_ROOT_DIR/$path"
  else
    source <(curl -fsSL "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/$path")
  fi
}

# ----------------------------------------------------------------------
# | Check Command                                                      |
# ----------------------------------------------------------------------

if [[ "${1:-}" =~ ^(install|backup|restore|test|iso)$ ]]; then
  cmd="$1"
elif [ -z "${1:-}" ] && command -v gum &>/dev/null; then
  cmd="interactive"
else
  usage
  exit 1
fi

# ----------------------------------------------------------------------
# | Init                                                               |
# ----------------------------------------------------------------------

[ ! -v DOTFILES_ROOT_DIR ] &&
  declare -r DOTFILES_ROOT_DIR="$HOME/.dotfiles"
[ ! -v CURRENT_BRANCH ] &&
  declare -r CURRENT_BRANCH=$(git -C "$DOTFILES_ROOT_DIR" branch --show-current 2>/dev/null || echo "main")
[ ! -v DOTFILES_GITHUB_RAW_CONTENT_ORIGIN ] &&
  declare -r DOTFILES_GITHUB_RAW_CONTENT_ORIGIN="https://raw.githubusercontent.com/omar-besbes/.dotfiles/$CURRENT_BRANCH"

source_or_fetch scripts/utils.sh

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

run_command "$cmd"