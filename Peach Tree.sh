#!/bin/sh
printf '\033c\033]0;%s\a' Peach Tree
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Peach Tree.x86_64" "$@"
