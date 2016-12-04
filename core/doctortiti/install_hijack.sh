#!/data/local/tmp/doctortiti/hack/bin/busybox sh

BUSYBOX="/data/local/tmp/doctortiti/hack/bin/busybox"

echo "Set permission for busybox bin"
chmod 775 ${BUSYBOX}

${BUSYBOX} echo "Remount system as writeable"
${BUSYBOX} mount -o remount,rw /system

${BUSYBOX} echo "Set permissons"
${BUSYBOX} chmod -R 755 /data/local/tmp/doctortiti/
${BUSYBOX} chmod -R 755 /data/local/tmp/doctortiti/*
${BUSYBOX} chmod 755 /data/local/tmp/doctortiti/
${BUSYBOX} chmod 755 /data/local/tmp/doctortiti/*
${BUSYBOX} chmod 755 /data/local/tmp/doctortiti/system/bin/*
${BUSYBOX} chmod 755 /data/local/tmp/doctortiti/system/bootstrap/bin/*

if [ ! -f "/system/bin/e2fsck_hijacked" ]; then
	${BUSYBOX} echo "Move original e2fsck to e2fsck_hijacked"
	${BUSYBOX} cp /system/bin/e2fsck /system/bin/e2fsck_hijacked
fi

${BUSYBOX} echo "Copy bootstrap files"
${BUSYBOX} cp -R /data/local/tmp/doctortiti/system/* /system/

${BUSYBOX} sleep 1

${BUSYBOX} echo "Remount system as readonly"
${BUSYBOX} mount -o remount,ro /system

BUSYBOX="/system/bootstrap/bin/busybox"

${BUSYBOX} echo "Delete installer"
${BUSYBOX} rm -Rf /data/local/tmp/doctortiti/

${BUSYBOX} echo "Reboot the device"
${BUSYBOX} reboot