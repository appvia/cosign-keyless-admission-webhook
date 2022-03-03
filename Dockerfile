FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:237e898d5ac0a95a0928a32f87d1c743f50b195838b46aa404e927bd877e331b as cosign

FROM node:17.6.0-alpine@sha256:250e9a093b861c330be2f4d1d224712d4e49290eeffc287ad190b120c1fe9d9f
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
