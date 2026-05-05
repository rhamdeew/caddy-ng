FROM golang:1.25-alpine AS builder
RUN apk add --no-cache git gcc musl-dev
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN xcaddy build \
    --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive \
    --output /usr/bin/caddy

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
