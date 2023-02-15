FROM alpine:latest as builder

ARG TARGETPLATFORM

WORKDIR /
COPY ./scaleway-ddns-* .

RUN export BINARY_PLATFORM="$(echo $TARGETPLATFORM | sed "s#/#-#g")" && \
    export REQUIRED_BINARY_NAME="scaleway-ddns-${BINARY_PLATFORM}" && \
    mv "./${REQUIRED_BINARY_NAME}/${REQUIRED_BINARY_NAME}" ./scaleway-ddns

FROM alpine:latest

WORKDIR /
COPY --from=builder ./scaleway-ddns .

RUN chmod +x ./scaleway-ddns

ENTRYPOINT ["./scaleway-ddns", "run"]
