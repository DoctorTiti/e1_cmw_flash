#!/data/local/tmp/doctortiti/hack/bin/busybox sh
chmod 775 /data/local/tmp/doctortiti/hack/bin/busybox

BUSYBOX="/data/local/tmp/doctortiti/hack/bin/busybox"

echo "Set permission for busybox bin"
chmod 775 /data/local/tmp/doctortiti/hack/bin/busybox

chmod 775 /data/local/tmp/doctortiti/fix/su

${BUSYBOX} echo "Remount system as writeable"
${BUSYBOX} mount -o remount,rw /system

${BUSYBOX} echo "Copy su"
${BUSYBOX} rm -rf /system/bin/su
${BUSYBOX} rm -rf /system/xbin/su
${BUSYBOX} cp /data/local/tmp/doctortiti/fix/su /system/bin/
chmod 775 /system/bin/su

${BUSYBOX} echo "Remount system as readonly"
${BUSYBOX} mount -o remount,ro /system
