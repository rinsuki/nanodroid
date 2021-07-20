FROM alpine:3.14 as build

RUN apk --no-cache add gcc make linux-headers musl-dev ncurses-dev ncurses-static zlib-dev zlib-static
WORKDIR /nano
ADD ./nano .
RUN ./configure LDFLAGS="-static -no-pie -s" --enable-utf8
RUN make -j 2

FROM scratch
WORKDIR /
COPY --from=build /nano/src/nano .