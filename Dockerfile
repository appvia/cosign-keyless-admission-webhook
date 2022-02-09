FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:45f2e26f0952acc938c56a145b95b039704eba4d8751cf48b04dccdaf2ae0b14 as cosign

FROM node:17.4.0-alpine@sha256:6f8ae702a7609f6f18d81ac72998e5d6f5d0ace9a13b866318c76340c6d986b2
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
