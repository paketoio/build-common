#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=common.sh
source "$(dirname "$0")"/common.sh

VERSION=$(cat "${ROOT}"/image/version)

printf "➜ Building Dependency Updater\n"
GO111MODULE=on GOPRIVATE="*" go get -ldflags='-s -w' github.com/paketo-buildpacks/libpak/cmd/update-image-dependency

printf "➜ Updating Dependency\n"
update-image-dependency \
  --builder-toml "${ROOT}"/source/builder.toml \
  --type "${TYPE}" \
  --version "${VERSION}"

cd "${ROOT}"/source

git add builder.toml
git checkout -- .

git \
  -c user.name='Paketo Robot' \
  -c user.email='robot@paketo.io' \
  commit \
  --signoff \
  --message "Dependency Upgrade: ${TYPE} Image ${VERSION}"
