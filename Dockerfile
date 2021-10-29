FROM gcr.io/projectsigstore/cosign:v1.2.1 as cosign
FROM node:16.13.0-alpine
COPY --from=cosign /bin/cosign /bin/cosign
WORKDIR /app

COPY package.json package-lock.json index.js ./
RUN npm install --production
USER 1000
EXPOSE 8080
CMD ["node", "index.js"]