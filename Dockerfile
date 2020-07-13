FROM alpine:latest

WORKDIR /app

COPY ./bin/main /app/

ENTRYPOINT ["/app/main"]