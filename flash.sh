#!/bin/bash

if [ -z $1 ]; then
	echo Flash the utility to the phone connected via USB in fastboot mode
	echo Usage:
	echo "$0 <boot.img> [s][r][b] [no-reboot?]"
	exit 1;
fi

bootimg=$1

if [ -z $2 ]; then
	opts="b";
else
	opts="$2";
fi

if [[ $opts == *"s"* ]]; then
        echo Flashing system...
        sudo fastboot flash system "$bootimg"
fi
if [[ $opts == *"r"* ]]; then
        echo Flashing recovery...
        sudo fastboot flash recovery "$bootimg"
fi
if [[ $opts == *"b"* ]]; then
				echo Flashing boot...
				sudo fastboot flash boot "$bootimg"
fi

if [ -z $3 ]; then
	echo Rebooting...
	sudo fastboot reboot
fi
