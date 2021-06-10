#!/bin/bash -l

set -e

if [ -n "$NPM_AUTH_TOKEN" ]; then
  # Respect NPM_CONFIG_USERCONFIG if it is provided, default to $HOME/.npmrc
  NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG-"$HOME/.npmrc"}"
  NPM_REGISTRY_URL="${NPM_REGISTRY_URL-registry.npmjs.org}"

  # Allow registry.npmjs.org to be overridden with an environment variable
  printf "//%s/:_authToken=%s\\nregistry=%s" "$NPM_REGISTRY_URL" "$NPM_AUTH_TOKEN" "$NPM_REGISTRY_URL" > "$NPM_CONFIG_USERCONFIG"
  chmod 0600 "$NPM_CONFIG_USERCONFIG"
fi

PACKAGE_VERSION=$(jq '.version' --raw-output ./package.json)

echo "************* Building v$PACKAGE_VERSION *************"

PUBLISH_TAG=latest
if [[ "$PACKAGE_VERSION" =~ ^0\.0\.0\- ]]
then
  PUBLISH_TAG=canary
elif [[ "$PACKAGE_VERSION" =~ \-rc ]]
then
  PUBLISH_TAG=next
fi

cd ./lib/$*

echo "**************** Installing ****************"
npm install

echo "**************** Building ****************"
npm run build

{
  echo "**************** Publishing ****************"
  npm version --allow-same-version $PACKAGE_VERSION && npm publish --tag $PUBLISH_TAG --access public
} || {
  # Bail out of publishing
  exit 0
}
