#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154

##########################################################################
# Project specific labels
#
# Names of namespaces and resources are determined by these labels.
##########################################################################

taito_project=strapi-template
taito_project_short=sttemplate # Max 10 characters
taito_random_name=strapi-template
taito_company=companyname
taito_family=
taito_application=template
taito_suffix=

# Namespace
taito_namespace=strapi-template-$taito_env

# Database defaults
taito_default_db_type=pg

# Template
template_version=1.0.0
template_name=STRAPI-TEMPLATE
template_source_git=git@github.com:TaitoUnited
