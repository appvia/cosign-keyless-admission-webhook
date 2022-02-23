FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:a24bfb1e223ecc9514f63cb9283025393b0b753bc3c3b0ee1a29626a66281245 as cosign

FROM node:17.6.0-alpine@sha256:4cd7597eff69e9e4603f926e21a2cfa9dff8c49fca72914a4e6428ebf9bc91d6
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
