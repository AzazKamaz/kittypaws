FROM rust:slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV CARGO_ROOT=/usr/local/cargo
ENV PATH=$CARGO_ROOT/bin:$PATH

WORKDIR /app

COPY . .

RUN cargo build --release && \
    cargo install --path .

RUN mkdir -p ~/.kittypaws/plugins/ && \
    cp -r ./tests/sut/test_plugin ~/.kittypaws/plugins/

RUN ./tests/run.sh
