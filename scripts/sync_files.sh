#!/bin/bash

sync_dotfiles() {

	git fetch
	git pull
	git submodule sync --recursive
	git submodule update --recursive

}

