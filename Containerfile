FROM ghcr.io/nostale3210/timesinkc-cosmic-nvidia:latest AS build

COPY mat /usr/bin/mat
COPY lib/ /usr/lib/mat/
COPY custom_content /.mat/custom_content
COPY mat /.mat/custom_content/usr/bin/mat
COPY lib/ /.mat/custom_content/usr/lib/mat/

COPY boot/90mat /usr/lib/dracut/modules.d/90mat
COPY boot/mat-boot.service /usr/lib/systemd/system/mat-boot.service
COPY boot/mat-boot.sh /usr/libexec/mat-boot.sh

COPY tools/librarizer .
COPY tools/dep_check .

RUN bash librarizer && \
    sed "/# Dependencies/r drc_libs" /usr/lib/dracut/modules.d/90mat/module-setup.sh && \
    sed -i "/# Dependencies/r drc_libs" /usr/lib/dracut/modules.d/90mat/module-setup.sh && \
    rm -f librarizer drc_libs

RUN bash dep_check && \
    rm -f dep_check

RUN chmod +x /usr/bin/mat && \
    chmod +x /usr/libexec/mat-boot.sh

RUN KVER="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
    mkdir -p "/.mat/custom_content/usr/lib/modules/$KVER/initramfs.img" && \
    dracut --no-hostonly --kver "$KVER" --reproducible -v --add "mat" \
    -f "/.mat/custom_content/usr/lib/modules/$KVER/initramfs.img"

RUN mat itemize && \
    mat hash
