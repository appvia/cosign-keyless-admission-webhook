FROM golang:1.17.2-alpine as cosign
RUN go install github.com/sigstore/cosign/cmd/cosign@v1.3.0

FROM node:17.0.1-alpine as node
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install
RUN node_modules/.bin/pkg --targets node16 --compress gzip index.js

FROM alpine:3.14.2
COPY --from=node /app/index /usr/local/bin/app
COPY --from=cosign /go/bin/cosign /usr/local/bin/cosign

USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD [ "/usr/local/bin/app" ]