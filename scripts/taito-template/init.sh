#!/bin/bash -e
: "${taito_company:?}"
: "${taito_vc_repository:?}"
: "${taito_vc_repository_alt:?}"

if [[ ${taito_verbose:-} == "true" ]]; then
  set -x
fi

if [[ ${taito_provider} != "gcp" ]]; then
  # Remove GCP specific stuff from terraform.yaml
  sed -i "s/serviceAccount://g" ./scripts/terraform.yaml
  sed -i "s/@.*gserviceaccount.com//g" ./scripts/terraform.yaml
fi

# Remove database SSL keys if they are not required
if [[ ${template_default_postgres_ssl_enabled} != "true" ]] ||
   [[ ${template_default_postgres_ssl_client_cert_enabled} != "true" ]]; then
  if [[ -f docker-compose-cicd.yaml ]]; then
    sed -i '/DATABASE_SSL_CERT/d' ./docker-compose-cicd.yaml
    sed -i '/database_ssl_cert/d' ./docker-compose-cicd.yaml
  fi
  sed -i '/database_ssl_cert/d' ./scripts/taito/testing.sh
  if [[ -f docker-compose-cicd.yaml ]]; then
    sed -i '/DATABASE_SSL_KEY/d' ./docker-compose-cicd.yaml
    sed -i '/database_ssl_key/d' ./docker-compose-cicd.yaml
  fi
  sed -i '/database_ssl_key/d' ./scripts/taito/testing.sh
fi
if [[ ${template_default_postgres_ssl_enabled} != "true" ]] ||
   [[ ${template_default_postgres_ssl_server_cert_enabled} != "true" ]]; then
  if [[ -f docker-compose-cicd.yaml ]]; then
    sed -i '/DATABASE_SSL_CA/d' ./docker-compose-cicd.yaml
    sed -i '/database_ssl_ca/d' ./docker-compose-cicd.yaml
  fi
  sed -i '/database_ssl_ca/d' ./scripts/taito/testing.sh
fi

echo
echo "Replacing project and company names in files. Please wait..."
find . -type f -exec sed -i \
  -e "s/sttemplate/${taito_project_short}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/strapi_template/${taito_vc_repository_alt}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/strapi-template/${taito_vc_repository}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/companyname/${taito_company}/g" 2> /dev/null {} \;
find . -type f -exec sed -i \
  -e "s/STRAPI-TEMPLATE/strapi-template/g" 2> /dev/null {} \;

echo "Generating unique random ports (avoid conflicts with other projects)..."
if [[ ! $ingress_port ]]; then ingress_port=$(shuf -i 8000-9999 -n 1); fi
if [[ ! $db_port ]]; then db_port=$(shuf -i 6000-7999 -n 1); fi
if [[ ! $server_debug_port ]]; then server_debug_port=$(shuf -i 4000-4999 -n 1); fi
sed -i "s/4229/${server_debug_port}/g" \
  docker-compose.yaml \
  scripts/taito/project.sh scripts/taito/env-local.sh \
  scripts/taito/TAITOLESS.md www/README.md &> /dev/null || :
sed -i "s/6000/${db_port}/g" \
  docker-compose.yaml \
  scripts/taito/project.sh scripts/taito/env-local.sh \
  scripts/taito/TAITOLESS.md www/README.md &> /dev/null || :
sed -i "s/9999/${ingress_port}/g" \
  docker-compose.yaml \
  scripts/terraform-dev.yaml \
  scripts/taito/project.sh scripts/taito/env-local.sh \
  scripts/taito/TAITOLESS.md www/README.md &> /dev/null || :

./scripts/taito-template/common.sh
echo init done
