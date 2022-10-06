#!/bin/sh

# TIP: If you want to install latest Strapi version from scratch,
# just delete the strapi/package.json file and restart the container.
# Note that by default Strapi uses port 1337 instead of 8080 and sqlite
# instead of PostgreSQL. Therefore you need to configure those yourself.

if [ ! -f strapi/package.json ]; then
  # Create new strapi app
  rm -rf strapi
  npx create-strapi-app@latest strapi --quickstart
else
  # Start the existing strapi app
  cd strapi
  npm install
  npm run develop
fi
