#!/bin/bash -e
: "${taito_company:?}"
: "${taito_vc_repository:?}"
: "${taito_vc_repository_alt:?}"

if [[ ${taito_verbose:-} == "true" ]]; then
  set -x
fi

if [[ ${template_default_kubernetes} ]] || [[ ${kubernetes_name} ]]; then
  # Remove serverless-http adapter since Kubernetes is enabled
  if [[ -d ./server ]]; then
    sed -i '/serverless/d' ./server/package.json
    sed -i '/serverless/d' ./server/src/server.ts
  fi

  # Remove server and graphql service accounts
  # (most likely not required for storage access with kubernetes)
  sed -i '/$taito_project-$taito_env-graphql/d' ./scripts/taito/project.sh
  sed -i '/$taito_project-$taito_env-server/d' ./scripts/taito/project.sh
  sed -i '/-graphql/d' ./scripts/terraform.yaml
  sed -i '/-server/d' ./scripts/terraform.yaml
else
  # Remove helm.yaml since kubernetes is disabled
  rm -f ./scripts/helm*.yaml

  if [[ ${taito_provider} == "aws" ]]; then
    # Use aws policy instead of service account
    sed -i '/SERVICE_ACCOUNT_KEY/d' ./scripts/terraform.yaml
    sed -i '/id: ${taito_project}-${taito_env}-server/d' ./scripts/terraform.yaml
    sed -i '/-storage-serviceaccount/d' ./scripts/taito/project.sh
    sed -i '/-storage.accessKeyId/d' ./scripts/taito/project.sh
    sed -i '/-storage.secretKey/d' ./scripts/taito/project.sh
  else
    # Use service account instead of aws policy
    sed -i "/^      awsPolicy:\r*\$/,/^\r*$/d" ./scripts/terraform.yaml
    sed -i '/BUCKET_REGION/d' ./scripts/terraform.yaml
  fi

  # Remove storage service account
  # (most likely not required for storage access with serverless)
  sed -i '/$taito_project-$taito_env-storage/d' ./scripts/taito/project.sh
  sed -i '-storage/d' ./scripts/terraform.yaml
fi

if [[ ${taito_provider} != "aws" ]]; then
  # Remove AWS specific stuff from implementation
  if [[ -d ./server ]]; then
    sed -i '/aws/d' ./server/src/common/config.ts
    sed -i '/prettier-ignore/d' ./server/src/common/config.ts
  fi
fi

if [[ ${taito_provider} != "gcp" ]]; then
  # Remove GCP specific stuff from terraform.yaml
  sed -i "s/serviceAccount://g" ./scripts/terraform.yaml
  sed -i "s/@.*gserviceaccount.com//g" ./scripts/terraform.yaml
fi

# Remove database SSL keys if they are not required
if [[ ${template_default_postgres_ssl_enabled} != "true" ]] ||
   [[ ${template_default_postgres_ssl_client_cert_enabled} != "true" ]]; then
  if [[ -f docker-compose-test.yaml ]]; then
    sed -i '/DATABASE_SSL_CERT/d' ./docker-compose-test.yaml
    sed -i '/database_ssl_cert/d' ./docker-compose-test.yaml
  fi
  sed -i '/database_ssl_cert/d' ./scripts/taito/testing.sh
  if [[ -f docker-compose-test.yaml ]]; then
    sed -i '/DATABASE_SSL_KEY/d' ./docker-compose-test.yaml
    sed -i '/database_ssl_key/d' ./docker-compose-test.yaml
  fi
  sed -i '/database_ssl_key/d' ./scripts/taito/testing.sh
fi
if [[ ${template_default_postgres_ssl_enabled} != "true" ]] ||
   [[ ${template_default_postgres_ssl_server_cert_enabled} != "true" ]]; then
  if [[ -f docker-compose-test.yaml ]]; then
    sed -i '/DATABASE_SSL_CA/d' ./docker-compose-test.yaml
    sed -i '/database_ssl_ca/d' ./docker-compose-test.yaml
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
  scripts/taito/project.sh scripts/taito/env-local.sh \
  scripts/taito/TAITOLESS.md www/README.md &> /dev/null || :

./scripts/taito-template/common.sh
echo init done
