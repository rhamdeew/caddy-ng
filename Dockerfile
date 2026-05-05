FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git gcc musl-dev
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN xcaddy build v2.8.4 \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@02be81e \
    --output /usr/bin/caddy

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
