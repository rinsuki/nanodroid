FROM alpine:3.14 as build

RUN apk --no-cache add gcc make linux-headers musl-dev zlib-dev zlib-static ncurses-terminfo
WORKDIR /ncurses
ADD ./ncurses .
RUN cp /etc/terminfo/x/xterm-256color /usr/share/terminfo/x/xterm-256color || true
RUN ./configure LDFLAGS="-static -no-pie -s" --disable-terminfo --with-fallbacks=xterm-256color,xterm-16color,xterm,vt100 --without-xterm-new --with-termlib --enable-termcap
RUN make -j 2
RUN make install

WORKDIR /nano
ADD ./nano .
RUN ./configure LDFLAGS="-static -no-pie -s" --enable-utf8
RUN make -j 2

FROM scratch
WORKDIR /
COPY --from=build /nano/src/nano .
CMD ["nano"]