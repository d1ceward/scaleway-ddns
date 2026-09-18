FROM alpine:3.24.2 AS builder

ARG TARGETPLATFORM

WORKDIR /
COPY ./scaleway-ddns-linux-amd64/scaleway-ddns-linux-amd64 .
COPY ./scaleway-ddns-linux-arm64/scaleway-ddns-linux-arm64 .

RUN export BINARY_PLATFORM="$(echo $TARGETPLATFORM | sed "s#/#-#g")" && \
    mv "./scaleway-ddns-${BINARY_PLATFORM}" ./scaleway-ddns

FROM alpine:3.24.2

WORKDIR /
COPY ./LICENSE .
COPY --from=builder --chmod=755 ./scaleway-ddns .

USER nobody

ENTRYPOINT ["./scaleway-ddns", "run"]
