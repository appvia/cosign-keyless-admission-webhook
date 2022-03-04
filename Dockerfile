FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:fabb56ef1905082e28dd572dc4f9cc19191f0cc4039512655659de8d5c2b97be as cosign

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
