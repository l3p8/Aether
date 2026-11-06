# The latest stable Rust, on Debian 12 (bookworm) like the image the binary runs in.
FROM rust:bookworm AS builder

WORKDIR /usr/src/app

COPY aether ./aether
COPY quiche ./quiche

WORKDIR /usr/src/app/aether

RUN cargo build --release --locked

FROM gcr.io/distroless/cc-debian12

WORKDIR /app

COPY --from=builder /usr/src/app/aether/target/release/aether /usr/local/bin/aether

ENV AETHER_SOCKS=0.0.0.0:1819
ENV AETHER_CONFIG=/data/aether.toml

VOLUME ["/data"]

EXPOSE 1819

ENTRYPOINT ["aether"]
