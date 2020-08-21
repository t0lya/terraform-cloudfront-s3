#!/bin/sh
set -e
set -x

if [ $# != 1 ]; then
    echo "usage: deploy.sh [terraform_stage: 'plan' | 'apply']"
    exit 1
fi

export $(grep -v '#.*' .env | xargs)
STAGE=$1

CONTAINER=$(
    docker create \
        --rm \
        -w /terraform \
        -e AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY \
        -e AWS_DEFAULT_REGION \
        -e AWS_ACCOUNT_ID \
        -e S3_BUCKET_NAME \
        hashicorp/terraform:0.12.29
        sh scripts/entrypoint.sh ${STAGE}
)

docker cp ./terraform/. ${CONTAINER}:/terraform/
docker cp ./lambda/. ${CONTAINER}:/lambda/

docker start -a ${CONTAINER}