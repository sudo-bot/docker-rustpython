# NAME: dclong/rustpython
FROM alpine:3.17 as builder

WORKDIR /workdir

# Newer rust needed due to let...else feature
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community rust cargo

RUN apk --no-cache add musl-dev

RUN cargo install  --root /workdir --git https://github.com/RustPython/RustPython --tag v0.2.0 --features freeze-stdlib --profile release

FROM alpine:3.17

RUN apk --no-cache add musl libgcc

COPY --from=builder /workdir/bin/rustpython /usr/local/bin/rustpython

RUN rustpython --version && \
    echo -e "import json\nprint(json.dumps([{'server': [{'tls': False}]}]))" | rustpython -q

ENTRYPOINT [ "/usr/local/bin/rustpython" ]
