FROM golang:1.17.6-alpine as cosign
RUN go install github.com/sigstore/cosign/cmd/cosign@v1.3.0

FROM node:17.2.0-alpine
COPY --from=cosign /go/bin/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
