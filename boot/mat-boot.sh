#!/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

[ -z "$1" ] && exit 1
sysroot="$1"

mat_boot=$(getarg mat.boot)
[ -z "$mat_boot" ] && exit 0

active_boot=$(cat "$sysroot/usr/.mat_dep" 2>/dev/null)
[ -z "$active_boot" ] && exit 1


[ "$active_boot" = "$mat_boot" ] && \
    echo "Current/Cmdline: $mat_boot" && \
    mount -o remount,rw "$sysroot" && \
    (mount -o bind,ro "$sysroot/usr" "$sysroot/usr" || printf "Couldn't bind mount /usr\n") && \
    (mount -o bind,rw "$sysroot/usr/local" "$sysroot/usr/local" || printf "Couldn't bind mount /usr/local\n") && \
    (mountpoint "$sysroot/.ald" >/dev/null 2>&1 || mount -o bind,ro "$sysroot/.ald" "$sysroot/.ald") && \
    (chattr +i "$sysroot/" || printf "Couldn't lock /.\n") && \
    exit 0

mount -o remount,rw "$sysroot"
[ ! -d "$sysroot/usr" ] && mkdir -p "$sysroot/usr"
[ ! -d "$sysroot/etc" ] && mkdir -p "$sysroot/etc"

echo "Current: $active_boot"
echo "Cmdline: $mat_boot (next)"

mat materialize "$mat_boot" --init /sysroot && \
    mat exch --init /sysroot && \
    mat clear --init /sysroot
