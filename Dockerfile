FROM rust:1.54 as api-builder
WORKDIR /usr/src/app
COPY api .
RUN cargo install --path .


FROM node as web-builder
WORKDIR /usr/src/app
COPY web .
RUN yarn install
RUN npm run build


FROM debian:buster-slim
RUN apt-get update && apt-get install -y sqlite3 && rm -rf /var/lib/apt/lists/*
COPY --from=api-builder /usr/local/cargo/bin/noir /app/noir
COPY --from=web-builder /usr/src/app/build/ /app/static/
CMD ["/app/noir", "--path", "/app/db.sqlite", "--alias", "/app/aliases.yaml", "server", "--root", "/app/static"]
