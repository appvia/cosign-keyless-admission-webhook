FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:70cc7226316e1c19a33c5b5e6208db9bf9babe7d044d446fdef60e46cae4d8f2 as cosign

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
