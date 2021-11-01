FROM golang:1.17.2-alpine as cosign
RUN go install github.com/sigstore/cosign/cmd/cosign@v1.2.1

FROM node:17.0.1-alpine

COPY --from=cosign /go/bin/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 1000
EXPOSE 8080
CMD ["node", "index.js"]
