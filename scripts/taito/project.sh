#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154

##########################################################################
# Project specific settings
##########################################################################

# Taito CLI: Project specific plugins (for the selected database, etc.)
taito_plugins="
  ${taito_plugins}
  postgres-db
"

# Environments: In the correct order (e.g. dev test uat stag canary prod)
taito_environments="${template_default_environments}"

# Basic auth: Uncomment the line below to disable basic auth from ALL
# environments. Use env-prod.sh to disable basic auth from prod
# environment only.
taito_basic_auth_enabled=false

# ------ Stack ------
# Configuration instructions:
# TODO

if [[ ${taito_deployment_platforms} == *"docker"* ]] ||
   [[ ${taito_deployment_platforms} == *"kubernetes"* ]]; then
  taito_containers="server"
  if [[ ${taito_env} == "local" ]]; then
    taito_containers="${taito_containers} database "
  fi
else
  taito_functions="server"
fi
taito_static_contents=""
taito_databases="database"
taito_networks="default"

# Buckets
taito_buckets="bucket"
st_bucket_name="$taito_random_name-${taito_env/local/dev}"

# ------ Secrets ------
# Configuration instructions:
# https://taitounited.github.io/taito-cli/tutorial/06-env-variables-and-secrets/

# Secrets for all environments
# NOTE: Using manual secrets so that they are copied from dev to local
# TODO: copy also random secrets
taito_secrets="
  $db_database_app_secret:manual
  ${db_database_mgr_secret}${taito_cicd_secrets_path}:manual
  $taito_project-$taito_env-storage.accessKeyId:manual
  $taito_project-$taito_env-storage.secretKey:manual
  $taito_project-$taito_env-strapi.adminJwtSecret:manual
  $taito_project-$taito_env-strapi.jwtSecret:manual
  $taito_project-$taito_env-strapi.appKeys:manual
  $taito_project-$taito_env-strapi.apiTokenSalt:manual
"

# Secrets for local environment only
taito_local_secrets="
"

# Secrets for non-local environments
taito_remote_secrets="
  $taito_project-$taito_env-basic-auth.auth:htpasswd-plain
  $db_database_viewer_secret:random
"

# Secrets required by CI/CD
taito_cicd_secrets="
  cicd-proxy-serviceaccount.key
  $db_database_mgr_secret
  $db_database_ssl_ca_secret
  $db_database_ssl_cert_secret
  $db_database_ssl_key_secret
"

# Secrets required by CI/CD tests
taito_testing_secrets="
  $taito_project-$taito_env-basic-auth.auth
"

# Secret hints and descriptions
taito_secret_hints="
  * basic-auth=Basic authentication is used to hide non-production environments from public
  * serviceaccount=Service account is typically used to access Cloud resources
  * jwt=JWT token is used for Strapi authentication
"

# ------ Links ------
# Add custom links here. You can regenerate README.md links with
# 'taito project generate'. Configuration instructions: TODO

link_urls="
  * server[:ENV]=$taito_app_url/admin Strapi admin GUI (:ENV)
  * git=https://$taito_vc_repository_url Git repository
"
