FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:0c85a04bae9c0bef5f56592e63122825e6b8305eaf0b2ec2023780da8ab909b4 as cosign

FROM node:17.5.0-alpine@sha256:0e83c810225bc29e614189acf3d6419e3c09881cefb9f7a170fdcfe3e15bbfd5
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
