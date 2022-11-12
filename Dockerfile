FROM alpine:latest

RUN apk --no-cache add curl

COPY ./scaleway-ddns .
RUN chmod +x /scaleway-ddns

ENTRYPOINT ["/scaleway-ddns", "run"]
