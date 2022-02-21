FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:531401a31154441158b0bde42938b90b43e6b754dec3cee2d9569813dc4ce8c6 as cosign

FROM node:17.5.0-alpine@sha256:0e83c810225bc29e614189acf3d6419e3c09881cefb9f7a170fdcfe3e15bbfd5
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
