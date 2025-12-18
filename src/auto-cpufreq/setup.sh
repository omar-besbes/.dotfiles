#!/bin/bash

# ----------------------------------------------------------------------
# | Symlinks                                                           |
# ----------------------------------------------------------------------

create_symlinks() {

  local -a FILES_TO_SYMLINK=("$TOPIC_DIR/auto-cpufreq.conf")
  local -r TARGET_PATHS=("$HOME/.config/auto-cpufreq/auto-cpufreq.conf")
  symlink_files FILES_TO_SYMLINK[@] TARGET_PATHS[@]

}

# ----------------------------------------------------------------------
# | Dependencies                                                       |
# ----------------------------------------------------------------------

install_dependencies() {

  # Optional, recommended to use with auto-cpufreq
  sudo apt-get update
  sudo apt-get install -y thermald 
  
  git clone https://github.com/AdnanHodzic/auto-cpufreq.git
  sudo auto-cpufreq/auto-cpufreq-installer --install
  is_ci || sudo auto-cpufreq --install
  rm -rf auto-cpufreq
  
  print_info '   [ℹ️] Please run `sudo auto-cpufreq --install` when install finishes'

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

  local DIR="$(dirname "${BASH_SOURCE[0]}")"
  local ROOT_DIR="$(realpath "$DIR/../..")"
  local TOPIC_NAME="auto-cpufreq"
  local TOPIC_DIR="$ROOT_DIR/src/$TOPIC_NAME"

  [ ! -v DOTFILES_ROOT_DIR ] && source "$ROOT_DIR/scripts/utils.sh"

  ask_for_sudo
  
  install_dependencies

  create_symlinks

}
