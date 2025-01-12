FROM ghcr.io/nostale3210/timesinkc-cosmic-nvidia:latest AS tmp

COPY mat /usr/bin/mat
COPY lib/ /usr/lib/mat/
COPY custom_content /.mat/custom_content
COPY mat /.mat/custom_content/usr/bin/mat
COPY lib/ /.mat/custom_content/usr/lib/mat/

RUN mat itemize


FROM alpine:latest

COPY --from=tmp /.mat /.mat
