FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:d8b5dd024184c9a225d51284a6e412a9860c1ab7b0761098af58507e7c263d6b as cosign

FROM node:17.7.1-alpine@sha256:d1d5dc5de1501601c6f5a1bcac25b5d2060f9127663ac41273a6abfcaa68569b
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
