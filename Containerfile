FROM ghcr.io/nostale3210/timesinkc-cosmic-nvidia:latest

COPY mat /usr/bin/mat
COPY lib/ /usr/lib/mat/

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

RUN sed -i "s/tsd upgrade/mat new -up -se -apply -gc/g" /usr/libexec/sys-up && \
    sed -i "s/\"bootc\"/\"mat\"/g" /usr/libexec/sys-up

RUN chmod 4755 /usr/bin/newgidmap && \
    chmod 4755 /usr/bin/newuidmap

RUN KVER="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
    dracut --no-hostonly --kver "$KVER" --reproducible -v --add "mat" \
    -f "/usr/lib/modules/$KVER/initramfs.img"

RUN mat itemize
