#!/bin/bash

version=$1
if [ -z $version ]
then
 echo 'Supply a version for this deployment, eg. buildanddeploy.sh 1.0.1'
 exit 1
fi

# Build, package and upload the app
echo 'Building, packaging and uploading the function to S3'
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main app/main.go

zip harryStamper.zip main

aws s3api create-bucket --bucket harry-stamper-eu-central-1 --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
aws s3 cp harryStamper.zip s3://harry-stamper-eu-central-1/harryStamper-$version.zip --region eu-central-1

aws s3api create-bucket --bucket harry-stamper-eu-west-1 --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
aws s3 cp harryStamper.zip s3://harry-stamper-eu-west-1/harryStamper-$version.zip --region eu-west-1

if [ $? -ne 0 ]
then
 echo 'Build, package or upload failed'
 exit 1
fi

# Deploy the infrastructure
echo 'Running Terraform, enter yes if you are comfortable with the changes'

cd terraform
terraform init
terraform apply -var="app_version=$version"

if [ $? -ne 0 ]
then
 echo 'Terraform run failed'
 exit 1
fi
