- A working and properly configured installation of Go (1.11.5)
 - AWS CLI
 - Terraform > 0.11.10
 - Environment variables for AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY populated with AWS credentials

# Installation


```sh
$ cd harry-stamper
$ bash buildanddeploy.sh
```
The function will be built and uploaded to an S3 bucket.  Terraform will be invoked and you will be prompted before committing changes to the infrastructure