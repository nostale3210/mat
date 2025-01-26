#!/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

[ -z "$1" ] && exit 1
sysroot="$1"

mat_boot=$(getarg mat.boot)
[ -z "$mat_boot" ] && exit 0

active_boot=$(cat "$sysroot/usr/.mat_dep" 2>/dev/null)
[ -z "$active_boot" ] && printf "Couldn't find current deployment. Dirty switch inc.!\n"


[ "$active_boot" = "$mat_boot" ] && \
    printf "Current/Cmdline: %s\n" "$mat_boot" && \
    mount -o remount,rw "$sysroot" && \
    (mount -o bind,ro "$sysroot/usr" "$sysroot/usr" || printf "Couldn't bind mount /usr\n") && \
    (mount -o bind,rw "$sysroot/usr/local" "$sysroot/usr/local" || printf "Couldn't bind mount /usr/local\n") && \
    (mountpoint "$sysroot/.mat" >/dev/null 2>&1 || mount -o bind,ro "$sysroot/.mat" "$sysroot/.mat") && \
    (chattr +i "$sysroot/" || printf "Couldn't lock /.\n") && \
    exit 0

mount -o remount,rw "$sysroot"
[ ! -d "$sysroot/usr" ] && mkdir -p "$sysroot/usr"
[ ! -d "$sysroot/etc" ] && mkdir -p "$sysroot/etc"

printf "Current: %s\n" "$active_boot"
printf "Cmdline: %s (next)\n" "$mat_boot"

mat exch "$mat_boot" --init "$sysroot"
