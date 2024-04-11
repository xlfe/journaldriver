FROM rust:latest

RUN apt update && apt upgrade -y
RUN apt install -y g++-aarch64-linux-gnu libc6-dev-arm64-cross
RUN dpkg --add-architecture arm64 && apt-get update
RUN apt-get install --assume-yes libssl-dev:arm64 libsystemd-dev:arm64

RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup toolchain install stable-aarch64-unknown-linux-gnu

WORKDIR /app

ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++

ENV PKG_CONFIG_SYSROOT_DIR=/usr/lib/aarch64-linux-gnu/pkgconfig
ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig

CMD ["cargo", "build", "--release", "--target", "aarch64-unknown-linux-gnu"]
