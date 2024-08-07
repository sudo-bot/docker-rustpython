FROM alpine:3.20 as builder

WORKDIR /workdir

ARG RUST_PYTHON_VERSION="0.3.1"
ARG BUILD_DATE
ARG VCS_REF

ENV CARGO_HOME="/workdir"
ENV CARGO_INSTALL_ROOT="/workdir"
# armv6 and armv7 fix
# See: https://github.com/rust-lang/cargo/issues/6513#issuecomment-1440029221
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

ADD https://github.com/RustPython/RustPython/archive/refs/tags/$RUST_PYTHON_VERSION.tar.gz /tmp/v$RUST_PYTHON_VERSION.tar.gz

RUN tar --strip-components=1 -C /workdir -xzf /tmp/v$RUST_PYTHON_VERSION.tar.gz

# Remove the git mode that triggers an error on armv6 and armv7
# Ref: https://github.com/rust-lang/cargo/issues/2808 (failed to mmap. Could not write data: Out of memory; class=Os (2))
RUN sed -i 's#{ git = .*#{ path = "/workdir/rp__doc__/" }#' /workdir/derive-impl/Cargo.toml

RUN apk add --no-cache rust cargo musl-dev git

RUN cargo fetch

RUN cargo build --features freeze-stdlib --release --locked --offline --bin rustpython

FROM alpine:3.20

RUN apk --no-cache add musl libgcc

COPY --from=builder /workdir/target/release/rustpython /usr/local/bin/rustpython
COPY <<-"EOT" /usr/local/share/sbom/rustpython.spdx.json
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

# Metadata
LABEL org.label-schema.vendor="Sudo-Bot" \
    org.label-schema.url="https://github.com/sudo-bot/docker-rustpython#readme" \
    org.label-schema.name="docker-rustpython" \
    org.label-schema.description="RustPython into Docker" \
    org.label-schema.version=${RUST_PYTHON_VERSION} \
    org.label-schema.vcs-url="https://github.com/sudo-bot/docker-rustpython.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.schema-version="1.0" \
    \
    com.docker.extension.publisher-url="https://github.com/sudo-bot" \
    \
    org.opencontainers.image.title="RustPython into Docker" \
    org.opencontainers.image.description="RustPython into Docker" \
    org.opencontainers.image.authors="williamdes@wdes.fr" \
    org.opencontainers.image.url="https://github.com/sudo-bot/docker-rustpython#readme" \
    org.opencontainers.image.documentation="https://github.com/sudo-bot/docker-rustpython#readme" \
    org.opencontainers.image.source="https://github.com/sudo-bot/docker-rustpython" \
    org.opencontainers.image.vendor="Sudo-Bot" \
    org.opencontainers.image.licenses="MPL-2.0" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.version=${RUST_PYTHON_VERSION} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.ref.name="${RUST_PYTHON_VERSION}"

ENTRYPOINT [ "/usr/local/bin/rustpython" ]
