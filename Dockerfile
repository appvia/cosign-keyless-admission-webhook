FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:5ef32124035de186934d54e24fc83713a6ad35f1efb795ae759c9d60be3c9db6 as cosign

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
