#!/system/bootstrap/bin/busybox sh

export PATH=/sbin:/system/xbin:/system/bin

BUSYBOX="/system/bootstrap/bin/busybox"
TOOLBOX="/system/bootstrap/bin/toolbox"

SETLEDCOLOR()
{
	${BUSYBOX} echo "$1" > /sys/class/leds/red/brightness
	${BUSYBOX} echo "$2" > /sys/class/leds/green/brightness
	${BUSYBOX} echo "$3" > /sys/class/leds/notification/brightness
}

REINIT()
{
	${BUSYBOX} cp /system/bootstrap/bin/2nd-init /bootstrap/2nd-init
	
	for SVCRUNNING in $(${TOOLBOX} getprop | ${BUSYBOX} grep -E '^\[init\.svc\..*\]: \[running\]')
	do
		SVCNAME=$(${BUSYBOX} expr ${SVCRUNNING} : '\[init\.svc\.\(.*\)\]:.*')
		
		stop ${SVCNAME}
		${BUSYBOX} killall -9 ${SVCNAME}
	done

	for RUNNINGPRC in $(${BUSYBOX} ps | ${BUSYBOX} grep /system/bin | ${BUSYBOX} grep -v ${BUSYBOX} | ${BUSYBOX} awk '{print $2}')
	do
		${BUSYBOX} killall -9 $RUNNINGPRC
	done

	for RUNNINGPRC in $(${BUSYBOX} ps | ${BUSYBOX} grep /sbin | ${BUSYBOX} grep -v ${BUSYBOX} | ${BUSYBOX} awk '{print $2}')
	do
		${BUSYBOX} killall -9 $RUNNINGPRC
	done
	
	SETLEDCOLOR 0 0 0
	
	for MOUNTPOINT in $(${BUSYBOX} mount | ${BUSYBOX} awk '{print $3}' | ${BUSYBOX} sort -r | ${BUSYBOX} grep -v '^/$' | ${BUSYBOX} grep -v '^/proc$')
	do
		${BUSYBOX} umount -l $MOUNTPOINT
	done

	${BUSYBOX} sync

	if [ -f "/bootstrap/ramdisk.tar.gz" ]; then
		for FILENAME in $(${BUSYBOX} ls / | ${BUSYBOX} grep -v '^bootstrap$' | ${BUSYBOX} grep -v '^proc$')
		do
			${BUSYBOX} rm -Rf $FILENAME
		done
		
		${BUSYBOX} tar xzf /bootstrap/ramdisk.tar.gz
		${BUSYBOX} rm -f /bootstrap/ramdisk.tar.gz
	fi
	
	/bootstrap/2nd-init
}

START_ADBD()
{
	if [ ! -f "/bootstrap/adbd" ]; then
		${BUSYBOX} cp /system/bootstrap/bin/adbd /bootstrap/adbd
	fi
	
	${BUSYBOX} echo 0 > /sys/class/android_usb/android0/enable
	${BUSYBOX} echo "18D1" > /sys/class/android_usb/android0/idVendor
	${BUSYBOX} echo "D001" > /sys/class/android_usb/android0/idProduct
	${BUSYBOX} echo "adb" > /sys/class/android_usb/android0/functions
	${BUSYBOX} echo 1 > /sys/class/android_usb/android0/enable
	/bootstrap/adbd &
}

SETLEDCOLOR 0 0 255

${BUSYBOX} mkdir /bootstrap
	
${BUSYBOX} cp ${BUSYBOX} /bootstrap/busybox
BUSYBOX="/bootstrap/busybox"

${BUSYBOX} cp ${TOOLBOX} /bootstrap/toolbox
TOOLBOX="/bootstrap/toolbox"

${BUSYBOX} cat /dev/input/event5 > /bootstrap/pon_key &
${BUSYBOX} cat /dev/input/event6 > /bootstrap/vol_key &
${BUSYBOX} sleep 3
${BUSYBOX} pkill -f "${BUSYBOX} cat"

if [ -s /bootstrap/vol_key -o -s /bootstrap/pon_key ] || ${BUSYBOX} grep -q warmboot=0x77665502 /proc/cmdline ; then
	${BUSYBOX} cp /system/bootstrap/recovery.tar.gz /bootstrap/ramdisk.tar.gz
	
	SETLEDCOLOR 255 255 255

	${BUSYBOX} sleep 1
	
	REINIT
fi

SETLEDCOLOR 0 255 0

${BUSYBOX} sleep 1

# ramdisk in a tar.gz file as /bootstrap/ramdisk.tar.gz

REINIT