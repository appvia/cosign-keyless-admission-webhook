FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:0c988869f255e87e6ff2f3748ccda9663188c7b0600ab9181a7c21646e7d8067 as cosign

FROM node:17.7.1-alpine@sha256:8c62619815dd2d7642f9e9c7f30d7016249a41175dfca0aaf248171960e4cc80
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
