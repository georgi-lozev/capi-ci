#!/bin/bash

set -eu

# INPUTS
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workspace_dir="$( cd "${script_dir}/../../../" && pwd )"
director_state="${workspace_dir}/director-state"
terraform_dir="${workspace_dir}/terraform"

creds_file="${director_state}/creds.yml"
terraform_metadata_file="${terraform_dir}/metadata"
terraform_name_file="${terraform_dir}/name"

# OUTPUTS
output_dir="${workspace_dir}/bosh-lite-env-info"

cat > "${output_dir}/metadata" <<EOD
export BOSH_CA_CERT="$(bosh interpolate --path /default_ca/ca "${creds_file}")"
export BOSH_CLIENT="admin"
export BOSH_CLIENT_SECRET="$(bosh interpolate --path /admin_password "${creds_file}")"
export BOSH_ENVIRONMENT="$(bosh interpolate --path /external_ip "${terraform_metadata_file}")"
export BOSH_GW_USER="jumpbox"
export BOSH_GW_HOST="$(bosh interpolate --path /external_ip "${terraform_metadata_file}")"
export BOSH_GW_PRIVATE_KEY_CONTENTS="$(bosh interpolate --path /jumpbox_ssh/private_key "${creds_file}")"
export BOSH_LITE_DOMAIN="$(bosh interpolate --path /system_domain "${terraform_metadata_file}")"
export CREDHUB_USERNAME="credhub-cli"
export CREDHUB_PASSWORD="$(bosh interpolate --path /credhub_cli_password "${creds_file}")"
EOD

cp "${terraform_name_file}" "${output_dir}/name"
