#!/bin/bash
set -e

IPSEC_IKE_PORT=${IPSEC_IKE_PORT:-500}
IPSEC_NATT_PORT=${IPSEC_NATT_PORT:-4500}

# Get OCP installer path, or use current directory
OCP_INS_DIR="$(realpath -- ${1:-.})"
METADATA_JSON="${OCP_INS_DIR}/metadata.json"

#if [ -z "$OS_AUTH_URL" ]; then
#    echo "Please source the credentials for OpenStack cluster using openrc file before running this script"
#    exit 1
#fi

# Get Terraform apply options, for the rest of args (if given)
if (( $# > 1 )) ; then
  shift
  TERRAFORM_ARGS=("$@") # e.g. -auto-approve -lock-timeout=3m
fi

# Set Github parameters
GITHUB_BRANCH="${GITHUB_BRANCH:-master}"
GITHUB_USERFORK="${GITHUB_USERFORK:-submariner-io}"
GITHUB_ARCHIVE="https://github.com/$GITHUB_USERFORK/submariner/archive/$GITHUB_BRANCH.tar.gz"

# Functions

req_install() {
  if ! command -v $1 >/dev/null 2>&1; then
    echo "$1 is required by this tool, please install $1" >&2
    exit 2
  fi
}

copy_osp_ocp_scripts() {
  echo "Copying osp-scripts to $OCP_INS_DIR directory"
  cp -af ./osp-scripts $OCP_INS_DIR/
  cd $OCP_INS_DIR/osp-scripts
}

# Check parameters
if [[ ! -d $OCP_INS_DIR ]] || [[ ! -f $METADATA_JSON ]]; then
  echo "Please provide a valid OpenShift installation directory as the first argument." >&2
  echo "Usage:" >&2
  echo "   $0 <ocp-install-path> [optional terraform apply arguments]" >&2
  echo "" >&2
  exit 1
fi

# Check pre-requisites
for cmd in wget terraform; do
  req_install $cmd
done


# Main

INFRA_ID=$(egrep -o -E '\"infraID\":\"([^\"]*)\"' $METADATA_JSON | cut -d: -f2 | tr -d \")
REGION=$(egrep -o -E '\"region\":\"([^\"]*)\"' $METADATA_JSON | cut -d: -f2 | tr -d \")

echo infraID: $INFRA_ID
echo region: $REGION

if [[ -z "$INFRA_ID" ]]; then
  echo "infraID could not be found in $METADATA_JSON" >&2
  exit 3
fi

if [[ -z "$REGION" ]]; then
  echo "region could not be found in $METADATA_JSON" >&2
  exit 4
fi

if [[ ! -d $OCP_INS_DIR/osp_scripts ]]; then
  copy_osp_ocp_scripts
fi

sed -r "s/(cluster_id = ).*/\1\"$INFRA_ID\"/" -i main.tf
sed -r "s/(os_region = ).*/\1\"$REGION\"/" -i main.tf
sed -r "s/(ipsec_natt_port = ).*/\1$IPSEC_NATT_PORT/" -i main.tf
sed -r "s/(ipsec_ike_port = ).*/\1$IPSEC_IKE_PORT/" -i main.tf
sed -r "s/(os_auth_url = ).*/\1\"$OS_AUTH_URL\"/" -i main.tf
sed -r "s/(os_user_name = ).*/\1\"$OS_USERNAME\"/" -i main.tf
sed -r "s/(os_password = ).*/\1\"$OS_PASSWORD\"/" -i main.tf
sed -r "s/(os_user_domain_name = ).*/\1\"$OS_USER_DOMAIN_NAME\"/" -i main.tf
sed -r "s/(os_tenant_name = ).*/\1\"$OS_PROJECT_NAME\"/" -i main.tf
sed -r "s/(os_project_domain_id = ).*/\1\"$OS_PROJECT_DOMAIN_ID\"/" -i main.tf
sed -r "s/(os_auth_url = ).*/\1\"$OS_AUTH_URL\"/" -i main.tf

terraform init
terraform apply "${TERRAFORM_ARGS[@]}"
