FROM alpine:3.24.1 AS builder

ARG TARGETPLATFORM

WORKDIR /
COPY ./scaleway-ddns-linux-amd64/scaleway-ddns-linux-amd64 .
COPY ./scaleway-ddns-linux-arm64/scaleway-ddns-linux-arm64 .

RUN export BINARY_PLATFORM="$(echo $TARGETPLATFORM | sed "s#/#-#g")" && \
    mv "./scaleway-ddns-${BINARY_PLATFORM}" ./scaleway-ddns

FROM alpine:latest

WORKDIR /
COPY ./LICENSE .
COPY --from=builder ./scaleway-ddns .

RUN chmod +x ./scaleway-ddns

ENTRYPOINT ["./scaleway-ddns", "run"]
