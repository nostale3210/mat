#!/bin/bash

installkernel() {
    return 0
}

check() {
    if [[ -x $systemdutildir/systemd ]] && [[ -x /usr/libexec/mat-boot.sh ]]; then
        return 255
    fi

    return 1
}

depends() {
    return 0
}

install() {
    dracut_install /usr/libexec/mat-boot.sh
    dracut_install /usr/lib/mat/switcher
    dracut_install /usr/lib/mat/materializer
    dracut_install /usr/bin/mat

    dracut_install /lib64/libacl.so.1
    dracut_install /lib64/libpopt.so.0
    dracut_install /lib64/liblz4.so.1
    dracut_install /lib64/libzstd.so.1
    dracut_install /lib64/libxxhash.so.0
    dracut_install /lib64/libcrypto.so.3
    dracut_install /lib64/libc.so.6
    dracut_install /lib64/libattr.so.1
    dracut_install /lib64/libz.so.1
    dracut_install /lib64/ld-linux-x86-64.so.2
    dracut_install /usr/bin/rsync
    dracut_install /usr/bin/exch

    dracut_install /lib64/libselinux.so.1
    dracut_install /lib64/libsepol.so.2
    dracut_install /lib64/libaudit.so.1
    dracut_install /lib64/libpcre2-8.so.0
    dracut_install /lib64/libcap-ng.so.0
    dracut_install /usr/sbin/setfiles

    inst_simple "${systemdsystemunitdir}/mat-boot.service"
    mkdir -p "${initdir}${systemdsystemconfdir}/initrd-root-fs.target.wants"
    ln_r "${systemdsystemunitdir}/mat-boot.service" \
        "${systemdsystemconfdir}/initrd-root-fs.target.wants/mat-boot.service"
}
