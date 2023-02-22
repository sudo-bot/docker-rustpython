# NAME: dclong/rustpython
FROM alpine:3.17 as builder

WORKDIR /workdir

ARG RUST_PYTHON_VERSION="0.2.0"
ENV CARGO_HOME="/workdir"
ENV CARGO_INSTALL_ROOT="/workdir"

# Newer rust needed due to let...else feature
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community rust cargo

RUN apk --no-cache add musl-dev

ADD https://github.com/RustPython/RustPython/archive/refs/tags/v$RUST_PYTHON_VERSION.tar.gz /tmp/v$RUST_PYTHON_VERSION.tar.gz
ADD https://github.com/RustPython/__doc__/archive/d927debd491e4c45b88e953e6e50e4718e0f2965.tar.gz /tmp/rp__doc__.tar.gz

RUN mkdir /workdir/rp__doc__/ && tar --strip-components=1 -C /workdir/rp__doc__/ -xzf /tmp/rp__doc__.tar.gz

RUN tar --strip-components=1 -C /workdir -xzf /tmp/v$RUST_PYTHON_VERSION.tar.gz

# Remove the git mode that triggers an error on armv6 and armv7
# Ref: https://github.com/rust-lang/cargo/issues/2808 (failed to mmap. Could not write data: Out of memory; class=Os (2))
RUN sed -i 's#{ git = .*#{ path = "/workdir/rp__doc__/" }#' /workdir/derive-impl/Cargo.toml

RUN cargo fetch

RUN if [ "$(uname -m)" != "ppc64le" ] && [ "$(uname -m)" != "s390x" ] && [ "$(uname -m)" != "aarch64" ]; then cargo build --features freeze-stdlib --release --locked --offline --bin rustpython; else cargo build --release --locked --offline --bin rustpython; fi

FROM alpine:3.17

RUN apk --no-cache add musl libgcc

COPY --from=builder /workdir/target/release/rustpython /usr/local/bin/rustpython
COPY <<-EOT /usr/local/share/sbom/rustpython.spdx.json
{
    "spdxVersion": "SPDX-2.3",
    "dataLicense": "CC0-1.0",
    "SPDXID": "SPDXRef-DOCUMENT",
    "name": "docker-rustpython",
    "packages": [
        {
            "name": "rustpython",
            "SPDXID": "SPDXRef-Package-binary-rustpython-${RUST_PYTHON_VERSION}",
            "versionInfo": "${RUST_PYTHON_VERSION}",
            "downloadLocation": "https://github.com/RustPython/RustPython",
            "sourceInfo": "Built from source at: https://github.com/RustPython/RustPython",
            "licenseConcluded": "MIT",
            "licenseDeclared": "MIT",
            "copyrightText": "NOASSERTION",
            "description": "rustpython"
        }
    ],
    "files": [
        {
            "SPDXID": "SPDXRef-rustpython-${RUST_PYTHON_VERSION}",
            "licenseConcluded": "MIT",
            "fileName": "/usr/local/bin/rustpython",
            "fileType": "BINARY"
        }
    ],
    "relationships": [
        {
            "spdxElementId": "SPDXRef-Package-binary-rustpython-${RUST_PYTHON_VERSION}",
            "relationshipType": "CONTAINS",
            "relatedSpdxElement": "SPDXRef-rustpython-${RUST_PYTHON_VERSION}"
        }
    ]
}
EOT

RUN rustpython --version && \
    echo -e "import json\nprint(json.dumps([{'server': [{'tls': False}]}]))" | rustpython -q

ENTRYPOINT [ "/usr/local/bin/rustpython" ]
