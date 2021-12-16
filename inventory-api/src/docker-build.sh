#!/bin/bash

set -eu -o pipefail

main()
{
  version='latest'
  image_name='bookstore.inventory-api'
  account_id=$(aws sts get-caller-identity | jq -r '.Account')
  image_tag="${account_id}.dkr.ecr.ap-southeast-2.amazonaws.com/${image_name}:${version}"

  docker build --rm --compress -t "${image_tag}" .

  aws ecr get-login-password | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.ap-southeast-2.amazonaws.com

  docker push "${image_tag}"
}

main "$@"
