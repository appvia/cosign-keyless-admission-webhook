FROM ghcr.io/sigstore/cosign/cosign:latest@sha256:ea008feb96c96663843df34438f85dd59d0298147f3835ca84d21e2186a8ba99 as cosign

FROM node:17.7.1-alpine@sha256:1cc03b302881bab0afe450fd51138718c81156d107427dbebb3c2301819620a7
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 10000
EXPOSE 8080/tcp
EXPOSE 8443/tcp
ENV COSIGN_EXPERIMENTAL=1
CMD ["node", "index.js"]
