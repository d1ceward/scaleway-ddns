# FROM alpine:latest as builder

# ARG TARGETPLATFORM

# WORKDIR /
# COPY ./release-binaries/scaleway-ddns-* .

# RUN export BINARY_PLATFORM="$(echo $TARGETPLATFORM | sed "s#/#-#g")" && \
#     export REQUIRED_BINARY_NAME="scaleway-ddns-${BINARY_PLATFORM}" && \
#     mv "./${REQUIRED_BINARY_NAME}" ./scaleway-ddns

FROM ubuntu:latest

WORKDIR /
COPY ./scaleway-ddns .
# COPY --from=builder ./scaleway-ddns .

RUN chmod +x ./scaleway-ddns

RUN apt-get update && apt-get install -y openssl build-essential libssl-dev libxml2-dev libyaml-dev libgmp-dev libz-dev libevent-dev libgc-dev libpcre3-dev curl sudo

ENTRYPOINT ["./scaleway-ddns", "run"]
