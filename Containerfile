FROM ghcr.io/nostale3210/timesinkc-cosmic-nvidia:latest AS tmp

COPY mat /usr/bin/mat
COPY lib/ /usr/lib/mat/
COPY custom_content /.mat/custom_content

RUN mat itemize


FROM alpine:latest AS delivery

COPY --from=tmp /.mat /
