#!/bin/bash

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
	echo "Usage: $0 <ramdisk.cpio.gz> <kernel.gz> <output.img>"
	exit 1
fi

ramdisk=$1
kernel=$2
output=$3

echo Creating $output from $ramdisk and $kernel...
#mkbootimg --kernel zImage --ramdisk ramdisk.cpio.gz -o archboot.img
mkbootimg --cmdline "'mmcparts=mmcblk0:p1(vrl),p2(vrl_backup),p6(modemnvm_factory),p9(splash),p10(modemnvm_backup),p11(modemnvm_img),p12(modemnvm_system),p14(3rdmodemnvm),p15(3rdmodemnvmbkp),p18(modem_om),p21(modemnvm_update),p31(modem),p32(modem_dsp),p35(3rdmodem) loglevel=4 androidboot.selinux=permissive'" --kernel_offset "-263716864" --ramdisk_offset "-134217728" --second_offset "-248020992" --tags_offset "-140509184" --kernel $kernel --ramdisk $ramdisk --output $output
#mkbootimg --cmdline "'no_console_suspend=1 console=null mmcparts=mmcblk0:p1(vrl),p2(vrl_backup),p6(modemnvm_factory),p9(splash),p10(modemnvm_backup),p11(modemnvm_img),p12(modemnvm_system),p14(3rdmodemnvm),p15(3rdmodemnvmbkp),p18(modem_om),p21(modemnvm_update),p31(modem),p32(modem_dsp),p35(3rdmodem) loglevel=4 androidboot.selinux=permissive'" --kernel_offset "-263716864" --ramdisk_offset "-134217728" --second_offset "-248020992" --tags_offset "-140509184" --kernel zImage --ramdisk ramdisk.cpio.gz -o doboot.img
#mkbootimg --kernel zImage --ramdisk newramdisk.cpio.gz --kernel_offset "-263716864" --ramdisk_offset "-134217728" -o doboot.img
#--cmdline "mmcparts=mmcblk0:p1(vrl),p2(vrl_backup),p6(modemnvm_factory),p9(splash),p10(modemnvm_backup),p11(modemnvm_img),p12(modemnvm_system),p14(3rdmodemnvm),p15(3rdmodemnvmbkp),p18(modem_om),p21(modemnvm_update),p31(modem),p32(modem_dsp),p35(3rdmodem) loglevel=4 androidboot.selinux=permissive"
#mkbootimg --kernel zImage --ramdisk ramdisk.cpio.gz --kernel_offset "-263716864" --ramdisk_offset "10631168" -o archboot.img
