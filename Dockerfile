FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:65513d270dc1de062cdfbbe89a35504df585bd968fc88436c7bd6b07ec0f2159 as cosign

FROM node:17.2.0-alpine@sha256:e64dc950217610c86f29aef803b123e1b6a4a372d6fa4bcf71f9ddcbd39eba5c
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
