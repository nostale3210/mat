#!ALD_PATH/init/safe/busybox sh

ALD_PATH/init/safe/busybox mount -o remount,rw /
if [ "$(ALD_PATH/init/safe/busybox cat ALD_PATH/current)" != "INSERT_DEPLOYMENT" ]; then
    ALD_PATH/init/safe/busybox chattr -i /
    ALD_PATH/init/safe/busybox mkdir -p /usr
    ALD_PATH/init/safe/busybox mkdir -p /etc
    if ALD_PATH/init/safe/exch /usr ALD_PATH/INSERT_DEPLOYMENT/usr; then
        ALD_PATH/init/safe/exch /etc ALD_PATH/INSERT_DEPLOYMENT/etc
        ALD_PATH/init/safe/busybox mv ALD_PATH/INSERT_DEPLOYMENT ALD_PATH/"$(ALD_PATH/init/safe/busybox cat ALD_PATH/current)"
        ALD_PATH/init/safe/busybox echo "INSERT_DEPLOYMENT" > ALD_PATH/current
        ALD_PATH/init/safe/busybox mkdir -p /usr/lib
        ALD_PATH/init/safe/busybox touch /usr/lib/os-release
    fi
fi

mount -o bind,ro /usr /usr
mount -o bind,rw /usr/local /usr/local
ALD_PATH/init/safe/busybox find ALD_PATH -mindepth 2 -maxdepth 2 -type d -name "usr" \
    -exec ALD_PATH/init/safe/busybox sh -c 'ALD_PATH/init/safe/busybox mountpoint {} &>/dev/null || ALD_PATH/init/safe/busybox mount -o bind,ro {} {}' \;
ALD_PATH/init/safe/busybox chattr +i /

exec /usr/sbin/init
