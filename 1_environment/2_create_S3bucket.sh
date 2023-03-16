Description: create S3 bucket in region eu-central-1, without publick access and with versioning

#!/bin/bash

# echo "Enter a name of S3 Bucket: "
# read bucket_name

bucket_name=cicd-terraform-state-2023-03-16

aws s3 mb s3://$bucket_name --region eu-central-1

aws s3api put-public-access-block \
    --bucket $bucket_name \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

aws s3api put-bucket-versioning --bucket $bucket_name --versioning-configuration Status=Enabled
