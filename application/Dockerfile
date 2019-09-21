FROM golang:1.12.5 as builder

WORKDIR /go/src/app
COPY src .
RUN pwd
RUN ls -l
RUN CGO_ENABLED=0 go build -o bin .
RUN ls -l

FROM alpine:latest as certs
RUN apk --update add ca-certificates
RUN apk --no-cache add curl

FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/app/bin /bin

ENTRYPOINT ["/bin"]
