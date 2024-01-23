# Builder, tester and runtime container for local development
FROM node:20-alpine

# Installing libvips-dev for sharp Compatability
RUN apk update && apk add build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev

# Init /develop for user USER_UID
ARG USER_UID=1001
RUN adduser -u "${USER_UID}" -G root -S developer || :
RUN mkdir -p /develop/strapi && \
  chown -R "${USER_UID}:0" /develop
WORKDIR /develop
USER "${USER_UID}"

ARG SERVICE_DIR=.
COPY --chown="${USER_UID}:0" \
     ${SERVICE_DIR}/start.sh \
     ${SERVICE_DIR}/package.json \
     ${SERVICE_DIR}/.npmrc \
     /develop/
COPY --chown="${USER_UID}:0" \
  ${SERVICE_DIR}/strapi/README.md \
  ${SERVICE_DIR}/strapi/package.* \
  ${SERVICE_DIR}/strapi/package-lock.* \
  /develop/strapi/
ENV NODE_ENV=development
RUN if [ -f strapi/package.json ]; then (cd strapi && npm install --loglevel warn); fi
ENV COMMON_URL http://localhost:9999
RUN npm run build

EXPOSE 8080
CMD ./start.sh
