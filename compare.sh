#!/bin/zsh
if [ -z $1 ] || [ -z $2 ]; then
	echo Compare two cpio files
	echo Usage:
	echo "$0 <ramdisk.cpio1> <ramdisk.cpio2>";
	exit 1;
fi
python ./cpioread.py $1 > /tmp/$1.txt
python ./cpioread.py $2 > /tmp/$2.txt
vimdiff /tmp/$1.txt /tmp/$2.txt
