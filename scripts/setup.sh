#!/bin/bash

declare -r GITHUB_REPOSITORY="omar-besbes/dotfiles"

declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

	cd "$HOME/.dotfiles"

	declare -a FILES_TO_SYMLINK=(
		# Shell related files		
      "shell/bash_logout"
      "shell/bash_profile"
      "shell/bashrc"
      "shell/inputrc"

		# Git related files
      "git/gitconfig"
	)	

	for i in "${FILES_TO_SYMLINK[@]}"; do

		sourceFile="$(pwd)/src/$i"
		targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

      if [ ! -e "$targetFile" ]; then
			ln -fs $sourceFile $targetFile
			echo "$targetFile → $sourceFile"

      elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
         echo "SYMLINK_SUCCESS: $targetFile → $sourceFile"

      fi

    done
}

main
