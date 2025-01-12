#!/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

[ -z "$1" ] && exit 1
sysroot="$1"


mat_boot=$(getarg mat.boot)
[ -z "$mat_boot" ] && exit 0

active_boot=$(cat "$sysroot"/.mat/.current 2>/dev/null)
[ -z "$active_boot" ] && exit 1


[ "$active_boot" = "$mat_boot" ] && exit 0

mat materialize "$mat_boot" --init "$sysroot"
mat relabel --init "$sysroot"
mat exch --init "$sysroot"
mat clear --init "$sysroot"
