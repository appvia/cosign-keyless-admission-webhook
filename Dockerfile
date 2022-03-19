FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:3765ae82acd3dffc9df6aab553bba5483b25c0dbb1e60b5d3308b0d2f834a4f0 as cosign

FROM node:17.7.2-alpine@sha256:1ef397a038d809785a1f787de87fbb496d10ee1b0565068289da1c5cac0d1fe4
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
