#!/usr/bin/sh
# Standard File Names

function filter { echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[][(){}<>!@#$%^&*+=;:?,]//g;s/ /-/g;s/_/-/g;s/---/-/g;'; }
function subfile { stdname=`filter "$1"` ; [ "$1" != "$stdname" ] &&  mv -- "$1" "$stdname" && echo "$stdname"; }
function subdir {
	pushd $1 > /dev/null || exit 1
	depth=`find . -type d | awk -F"/" 'NF > max {max = NF} END {print max}'`
	for i in `seq 1 "$depth"`; do 
		find ./ -mindepth "$i" -maxdepth "$i" -type f,d -print0 | sed 's/\.\// /g' | while line= read -r -d '' file; do
			[ -z "$file" ] && continue
			subfile "$file"
		done
	done
	popd > /dev/null
}
[ -z "$1" ] && fpath="$(pwd)" || fpath="$1"
[ -f "$fpath" ] && subfile "$fpath" && exit 0
[ -d "$fpath" ] && subdir "$fpath" 

