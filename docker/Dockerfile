# NAME: dclong/rustpython
FROM alpine:3.17 as builder

WORKDIR /workdir

ARG RUST_PYTHON_VERSION="0.2.0"
ENV CARGO_HOME="/workdir"
ENV CARGO_INSTALL_ROOT="/workdir"

# Newer rust needed due to let...else feature
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community rust cargo

RUN apk --no-cache add musl-dev git

ADD https://github.com/RustPython/RustPython/archive/refs/tags/v$RUST_PYTHON_VERSION.tar.gz /tmp/v$RUST_PYTHON_VERSION.tar.gz

RUN tar --strip-components=1 -C /workdir -xzf /tmp/v$RUST_PYTHON_VERSION.tar.gz

RUN cargo fetch --locked

RUN cargo build --features freeze-stdlib --release --locked --offline --bin rustpython

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
