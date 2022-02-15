FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:08340b5767aa4182ecf297a3ee66239d9a155535447d2e257d373ea7b914f90b as cosign

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
