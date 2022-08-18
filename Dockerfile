FROM rust:1.54 as api-builder
WORKDIR /usr/src/app
COPY api .
RUN cargo install --locked --path .


FROM node as web-builder
WORKDIR /usr/src/app
COPY client .
RUN yarn install
RUN yarn build


FROM debian:buster-slim
RUN apt-get update && apt-get install -y sqlite3 libcurl4 && rm -rf /var/lib/apt/lists/*
COPY --from=api-builder /usr/local/cargo/bin/noir /app/noir
COPY --from=web-builder /usr/src/app/build/ /app/static/
ENV RUST_LOG info
ENV RUST_BACKTRACE 1
CMD ["/app/noir", "--path", "/app/db.sqlite", "--alias", "/app/aliases.yaml", "server", "--root", "/app/static", "--download-to", "/app/download"]
