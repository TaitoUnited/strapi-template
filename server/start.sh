#!/bin/sh

# TIP: If you want to install latest Strapi version from scratch,
# just delete the strapi/package.json file and restart the container.
# Note that by default Strapi does not read config from environment
# variables and secrets. Therefore you need to configure those yourself
# on strapi/config. You need to also change database settings.

if [ ! -f strapi/package.json ]; then
  # Create new strapi app
  rm -rf strapi
  npx create-strapi-app@latest strapi --quickstart
else
  # Start the existing strapi app
  cd strapi
  npm install

  # For some reason 'npm run build' needs to run again on start
  # for COMMON_URL to apply
  npm run build
  
  npm run develop
fi
