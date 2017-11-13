if [ -z $1 ] || [ -z $2 ]; then
	echo Usage:
	echo "$0 <ramdisk.cpio> <directory>";
	exit 1;
fi

if [ ! -d $2 ]; then
	echo "Error: Directory '$2' does not exist.";
	exit 2;
fi

cpio -t < $1 > cpio.filelist
cd $2
cpio -i < ../$1
