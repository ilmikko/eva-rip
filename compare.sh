#!/bin/zsh
if [ -z $1 ] || [ -z $2 ]; then
	echo Compare two cpio files
	echo Usage:
	echo "$0 <ramdisk.cpio1> <ramdisk.cpio2>";
	exit 1;
fi
python ./cpioread.py $1 > /tmp/PYPUT1
python ./cpioread.py $2 > /tmp/PYPUT2
vimdiff /tmp/PYPUT*
