#!/bin/bash

[ ! -v  TOPIC_UNINSTALL_FILE ] && declare -r TOPIC_UNINSTALL_FILE="uninstall.sh"

uninstall_topics() {
	
	local -r SOURCE_DIR=$1
	local -a TOPICS_TO_SETUP=$(find $SOURCE_DIR -mindepth 2 -maxdepth 2 -type f -name $TOPIC_SETUP_FILE -exec dirname {} \; 2>/dev/null)

	for i in ${TOPICS_TO_SETUP[@]}; do

		execute "source $i/$TOPIC_SETUP_FILE && main" "Setting up $(basename $i) ..."

	done

}

