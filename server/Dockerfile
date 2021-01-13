# Builder, tester and runtime container for local development
# NOTE: npm libraries are installed inside container to speed up build
FROM strapi/strapi:3-alpine
ARG SERVICE_DIR=.
WORKDIR /develop
ENV NODE_ENV development
COPY ${SERVICE_DIR}/package.json \
  ${SERVICE_DIR}/package-lock.* \
  /develop/
RUN npm install --loglevel warn
EXPOSE 8080
CMD npm install; strapi develop
