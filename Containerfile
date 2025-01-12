FROM ghcr.io/nostale3210/timesinkc-cosmic-nvidia:latest AS tmp

COPY mat /usr/bin/mat
COPY lib/ /usr/lib/mat/
COPY custom_content /.mat/custom_content
COPY mat /.mat/custom_content/usr/bin/mat
COPY lib/ /.mat/custom_content/usr/lib/mat/

COPY boot/90mat /usr/lib/dracut/modules.d/90mat
COPY boot/mat-boot.service /usr/lib/systemd/system/mat-boot.service
COPY boot/mat-boot.sh /usr/libexec/mat-boot.sh

RUN KVER="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')" && \
    mkdir -p "/.mat/custom_content/usr/lib/modules/$KVER/initramfs.img" && \
    dracut --no-hostonly --kver "$KVER" --reproducible -v --add "mat" \
    -f "/.mat/custom_content/usr/lib/modules/$KVER/initramfs.img"

RUN mat itemize

RUN rm -rf /var


FROM alpine:latest AS tgt

COPY --from=tmp /.mat /.mat
