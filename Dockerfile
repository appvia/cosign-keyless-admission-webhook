FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:0c85a04bae9c0bef5f56592e63122825e6b8305eaf0b2ec2023780da8ab909b4 as cosign

FROM node:17.5.0-alpine@sha256:570ce8a18bedac3f7263dc1563331681d6eaad72ce133b995b9be38c04db3627
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
