#!/bin/bash
set -euo pipefail

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
# | Run Command                                                        |
# ----------------------------------------------------------------------

run_command() {
  case "${1:-}" in
    install)
      (source scripts/install.sh)
      source ~/.bashrc
      ;;
    backup)
      (source scripts/backup.sh)
      ;;
    restore)
      (source scripts/restore.sh)
      ;;
    test)
      (source test/test.sh)
      ;;
    interactive)
      if command -v gum &>/dev/null; then
        run_command $(gum choose "install" "backup" "restore" "test")
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
# | Check Command                                                      |
# ----------------------------------------------------------------------

if [ "${1:-}" = "install" ] || [ "${1:-}" = "backup" ] || [ "${1:-}" = "restore" ] || [ "${1:-}" = "test" ]; then
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

[ ! -v CURRENT_BRANCH ] &&
  declare -r CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
[ ! -v DOTFILES_GITHUB_RAW_CONTENT_ORIGIN ] &&
  declare -r DOTFILES_GITHUB_RAW_CONTENT_ORIGIN="https://raw.githubusercontent.com/omar-besbes/.dotfiles/$CURRENT_BRANCH"

if [ -n "${DOTFILES_ROOT_DIR:-}" ] && [ -f "$DOTFILES_ROOT_DIR/scripts/utils.sh" ]; then
    source "$DOTFILES_ROOT_DIR/scripts/utils.sh"
else
    source <(curl -fsSL "$DOTFILES_GITHUB_RAW_CONTENT_ORIGIN/scripts/utils.sh")
fi

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

run_command "$cmd"
