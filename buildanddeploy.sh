#!/bin/bash


# Deploy the infrastructure
echo 'Running Terraform, enter yes if you are comfortable with the changes'

terraform plan terraform/
terraform apply terraform/

if [ $? -ne 0 ]
then
 echo 'Terraform run failed'
 exit 1
fi


# Build, package and upload the app
echo 'Building, packaging and uploading the function to S3'
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main app/main.go

zip harryStamper.zip main

aws s3api create-bucket --bucket=harry-stamper --region=eu-west-1
aws s3 cp harryStamper.zip s3://harry-stamper/harryStamper.zip

if [ $? -ne 0 ]
then
 echo 'Build, package or upload failed'
 exit 1
fi
