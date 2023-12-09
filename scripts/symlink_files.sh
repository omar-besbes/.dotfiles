#!/bin/bash

symlink_files() {
	
	local -a FILES_TO_SYMLINK=$1
	local -r SOURCE_DIR=$2
	local -r TARGET_DIR=$3
	# Check if a function to get target file name was passed and
	# use the identity function if not.
	if [ -n "$4" ]; then
		local -r GET_TARGET_FILE="$4"
	else
		GET_TARGET_FILE() {
			echo "$1"
		}
	fi

	for i in "${FILES_TO_SYMLINK[@]}"; do

		sourceFile="$SOURCE_DIR/$i"
		targetFile="$TARGET_DIR/$(GET_TARGET_FILE $i)"

      if [ ! -e "$targetFile" ]; then
			ln -fs $sourceFile $targetFile
			echo "$targetFile → $sourceFile"

      elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
         echo "SYMLINK_SUCCESS: $targetFile → $sourceFile"

      fi

    done

}

