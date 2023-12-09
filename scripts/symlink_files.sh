#!/bin/bash

symlink_files() {
	
	local -a FILES_TO_SYMLINK=$1
	local -r SOURCE_DIR=$2
	local -r TARGET_DIR=$3
	local -r GET_TARGET_FILE="$4"

	for i in "${FILES_TO_SYMLINK[@]}"; do

		sourceFile="$SOURCE_DIR/$i"
		targetFile="$TARGET_DIR/$(GET_TARGET_FILE $i 2>/dev/null || echo $i)"

      if [ ! -e "$targetFile" ]; then
			ln -fs $sourceFile $targetFile
			echo "$targetFile → $sourceFile"

      elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
         echo "SYMLINK_SUCCESS: $targetFile → $sourceFile"

      fi

    done

}

