FROM alpine:latest AS downloader
RUN apk add --no-cache curl tar xz
ARG NAIVE_VERSION=v2.11.2-naive
RUN curl -fsSL "https://github.com/klzgrad/forwardproxy/releases/download/${NAIVE_VERSION}/caddy-forwardproxy-naive.tar.xz" \
    | tar xJ --strip-components=1 caddy-forwardproxy-naive/caddy \
    && mv caddy /usr/bin/caddy

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=downloader /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
