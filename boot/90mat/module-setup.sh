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
    dracut_install /usr/lib/mat/locker
    dracut_install /usr/lib/mat/materializer
    dracut_install /usr/bin/mat

    inst_simple "${systemdsystemunitdir}/mat-boot.service"
    mkdir -p "${initdir}${systemdsystemconfdir}/initrd-root-fs.target.wants"
    ln_r "${systemdsystemunitdir}/mat-boot.service" \
        "${systemdsystemconfdir}/initrd-root-fs.target.wants/mat-boot.service"

    # Dependencies
}
