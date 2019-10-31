#!/bin/bash

# $ brew install jpegoptim 
# $ brew install optipng

export PATH=/usr/local/bin:$PATH

for file in "$@"
do
	filename=$(basename "${file}")
	extension="$(echo ${filename##*.} | tr '[:upper:]' '[:lower:]')"
	filesize_before=$(stat -f%z "${file}")

	case "${extension}" in
	'png' )
		optipng -o3 -preserve -quiet "${file}";;
	'jpg'|'jpeg' ) 
		jpegoptim --max=80 -o --preserve --preserve-perms --strip-all --quiet "${file}"	;;
	*) 
		echo "Cannot compress ${file}!"
		continue
		;;
	esac

	filesize_after=$(stat -f%z "${file}")
	reduction=$(printf "%.1f\n" $(echo "100.0-100.0/${filesize_before}*${filesize_after}" | bc -l))
	echo "Compressed ${filename} -- saved ${reduction}%!"
done

afplay /System/Library/Sounds/Submarine.aiff &
