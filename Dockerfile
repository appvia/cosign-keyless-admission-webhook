FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:9e5c2f2edc34351160407ca3416c61855bdf9403c3c5936e0f0be7fc261611b8 as cosign

FROM node:18.6.0-alpine@sha256:cd8f5b451e927f3c5c92016cfaf9d6805999faeded64486d8f76c9d4ef6f1b5c
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
