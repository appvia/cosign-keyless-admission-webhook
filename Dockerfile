FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:33a6a55d2f1354bc989b791974cf4ee00a900ab9e4e54b393962321758eee3c6 as cosign

FROM node:18.6.0-alpine@sha256:b90b63a402958508763900643576333fbf560033191d4426da14b14f91e8d3b0
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
