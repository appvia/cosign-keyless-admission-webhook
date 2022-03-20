FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:33a6a55d2f1354bc989b791974cf4ee00a900ab9e4e54b393962321758eee3c6 as cosign

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
