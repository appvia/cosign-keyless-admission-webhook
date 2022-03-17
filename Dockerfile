FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:d189ae9562c6701b0aace6cda4851a3e4ee21dec2cc1e5f369399ef15efe05f6 as cosign

FROM node:17.7.1-alpine@sha256:e0419acec75ab3eb99f74641e82647d10c1da959bbbf007d4e26a170894590c3
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
