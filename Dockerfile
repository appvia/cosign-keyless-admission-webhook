FROM golang:1.17.2-alpine as cosign
# need a bleeding edge feature from https://github.com/sigstore/cosign/commit/bfeb7d475f324abe6878e7f0320625e16b36a060
# can probably be v1.2.2 when that is released
RUN go install github.com/sigstore/cosign/cmd/cosign@bfeb7d475f324abe6878e7f0320625e16b36a060

FROM node:17.0.1-alpine
COPY --from=cosign /go/bin/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
