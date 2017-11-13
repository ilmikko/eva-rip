if [ -z $1 ]; then
	echo Usage:
	echo "$0 <directory>";
	exit 1;
fi

if [ ! -d $1 ]; then
	echo "Error: Directory '$1' does not exist.";
	exit 2;
fi

echo Finding files in $1...
cd $1
find . -depth | sort | cpio -o -H newc > ../newramdisk.cpio
echo Fixing cpio...
python ../cpiofix.py ../newramdisk.cpio
echo Compressing...
gzip -f ../newramdisk.cpio.fixed
echo You can find the compressed archive at
echo newramdisk.cpio.fixed.gz
