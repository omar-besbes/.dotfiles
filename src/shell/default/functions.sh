#!/bin/bash

for theme in $(vivid themes); do
    echo "Theme: $theme"
    LS_COLORS=$(vivid generate $theme)
    tree .dotfiles
    echo
done

