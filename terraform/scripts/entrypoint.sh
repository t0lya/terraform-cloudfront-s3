#!/bin/sh
set -e
set -x

if [ $# != 1 ]; then
    echo "usage: entrypoint.sh [terraform_stage: 'plan' | 'apply']"
    exit 1
fi

STAGE=$1
export TF_VAR_aws_region=$AWS_DEFAULT_REGION
export TF_VAR_s3_bucket_name=$S3_BUCKET_NAME
export TF_VAR_aws_account_id=$AWS_ACCOUNT_ID

terraform init
if [ "$STAGE" = "apply" ]
then
    terraform apply -auto-approve
else
    terraform plan
fi

echo "Distro is live at: $(terraform output cf_distro_url)"