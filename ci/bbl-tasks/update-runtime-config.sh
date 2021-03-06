#!/bin/bash
set -eu

function setup_bosh_env_vars() {
  echo "Setting env vars..."
  pushd "bbl-state/${BBL_STATE_DIR}"
    eval "$(bbl print-env)"
  popd
}

function update_bosh_runtime_config() {
  echo "Updating bosh cloud-config on ${BOSH_ENVIRONMENT}..."
  pushd "bbl-state/${BBL_STATE_DIR}"
    bosh -n update-runtime-config ../../capi-ci/bosh-deployment-files/bosh-dns-runtime-config.yml
  popd
}

function main() {
  setup_bosh_env_vars
  update_bosh_runtime_config
  echo "Done"
}

main
