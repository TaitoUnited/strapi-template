# Configuration

This file has been copied from [STRAPI-TEMPLATE](https://github.com/TaitoUnited/STRAPI-TEMPLATE/). Keep modifications minimal and improve the [original](https://github.com/TaitoUnited/STRAPI-TEMPLATE/blob/dev/scripts/taito/CONFIGURATION.md) instead.

## Prerequisites

* [npm](https://github.com/npm/cli) that usually ships with [Node.js](https://nodejs.org/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Taito CLI](https://taitounited.github.io/taito-cli/) (or see [TAITOLESS.md](TAITOLESS.md))
* Optional: Some editor plugins for linting and formatting (e.g. [ESLint](https://eslint.org/docs/user-guide/integrations#editors) and [Prettier](https://prettier.io/docs/en/editors.html) for JavaScript/TypeScript)

## Basic settings

1. Run `taito open conventions` in the project directory to see organization specific settings that you should configure for your git repository. At least you should set `dev` as the default branch to avoid people using master branch for development by accident.
2. Modify `scripts/taito/project.sh` if you need to change some settings. The default settings are ok for most projects.
3. Run `taito project apply`
4. Commit and push changes

* [ ] All done

## Your first remote environment (dev)

NOTE: The local development environment uses dev environment database and storage bucket. Therefore you have to create the dev environment first.

Make sure your authentication is in effect:

    taito auth:dev

Create the environment:

    taito env apply:dev

OPTIONAL: If the git repository is private, you may choose to write down the basic auth credentials to [README.md#links](../../README.md#links):

    EDIT README.md                # Edit the links section

Push some changes to dev branch with a [Conventional Commits](http://conventionalcommits.org/) commit message (e.g. `chore: configuration`):

    taito stage                   # Or just: git add .
    taito commit                  # Or just: git commit -m 'chore: configuration'
    taito push                    # Or just: git push

See it build and deploy:

    taito open builds:dev
    taito status:dev
    taito open client:dev
    taito open server:dev

> The first CI/CD run takes some time as build cache is empty. Subsequent runs should be faster.

> If CI/CD deployment fails on permissions error during the first run, the CI/CD account might not have enough permissions to deploy all the changes. In such case, execute the deployment manually with `taito deployment deploy:dev IMAGE_TAG`, and the retry the failed CI/CD build.

> If CI/CD tests fail on certificate error during the first CI/CD run, just retry the CI/CD run. Certificate manager probably had not retrieved the certificate yet.

> If you have some trouble creating an environment, you can destroy it by running `taito env destroy:dev` and then try again with `taito env apply:dev`.

* [ ] All done

## Local development environment

NOTE: The local development environment uses dev environment database and storage bucket. You have to create the dev environment first.

Make sure your authentication is in effect:

    taito auth:dev

Start your local development environment:

    taito kaboom

Open Strapi server GUI:

    taito open server

> If the application fails to start, run `taito trouble` to see troubleshooting. More information on local development you can find from [DEVELOPMENT.md](DEVELOPMENT.md).

## Create Strapi webhooks to preview or publish your site

On Strapi admin GUI (Settings -> Webhooks) you can configure webhooks to trigger your website build automatically. For example, to use Strapi with the [website-template](https://github.com/TaitoUnited/website-template) preview webhook mechanism, add the following webhook for entry create, update, and delete events:

    https://USER:PASSWORD@aarni-website-dev.taitodev.com/webhook/SECRET/publish-for-strapi

---

## Remote environments

You can create the other environments just like you did the dev environment. However, you don't need to write down the basic auth credentials anymore, since you can reuse the same credentials as in dev environment.

Project environments are configured in `scripts/taito/project.sh` with the `taito_environments` setting. Examples for environment names: `f-orders`, `dev`, `test`, `uat`, `stag`, `canary`, `prod`.

See [remote environments](https://taitounited.github.io/taito-cli/tutorial/05-remote-environments) chapter of Taito CLI tutorial for more thorough instructions.

Operations on production and staging environments usually require admin rights. Please contact DevOps personnel if necessary.

## Kubernetes

The `scripts/heml.yaml` file contains default Kubernetes settings for all environments and the `scripts/helm-*.yaml` files contain environment specific overrides for them. By modifying these files you can easily configure environment variables, resource requirements and autoscaling for your containers.

You can deploy configuration changes without rebuilding with the `taito deployment deploy:ENV` command.

> Do not modify the helm template located in `./scripts/helm` directory. Improve the original helm template located in [STRAPI-TEMPLATE](https://github.com/TaitoUnited/STRAPI-TEMPLATE/) repository instead.

## Secrets

You can add a new secret like this:

1. Add a secret definition to the `taito_secrets` or the `taito_remote_secrets` setting in `scripts/taito/project.sh`.
2. Map the secret definition to a secret in `docker-compose.yaml` for Docker Compose and in `scripts/helm.yaml` for Kubernetes.
3. Run `taito secret rotate:ENV SECRET` to generate a secret value for an environment. Run the command for each environment separately. Note that the rotate command restarts all pods in the same namespace.

You can use the following types in your secret definition:

- `random`: Randomly generated string.
- `manual`: Manually entered string.
- `file`: File. The file path is entered manually.
- `htpasswd`: htpasswd file that contains 1-N user credentials. User credentials are entered manually.
- `htpasswd-plain`: htpasswd file that contains 1-N user credentials. Passwords are stored in plain text. User credentials are entered manually.
- `csrkey`: Secret key generated for certificate signing request (CSR).

> See the [Environment variables and secrets](https://taitounited.github.io/taito-cli/tutorial/06-env-variables-and-secrets) chapter of Taito CLI tutorial for more instructions.
