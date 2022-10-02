#!/bin/bash +x

while getopts g:s: flag
do
    case "${flag}" in
        g) gc_bucketname=${OPTARG};;
        s) aws_bucketname=${OPTARG};;
    esac
done

# gc_bucketname="my0001"
# aws_bucketname="assd11"

aws --version
status=$?
if test $status -eq 0
then
    echo "CLI was installed"
else
    echo "AWS ClI is present on this machine. Skipping install setp"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

echo "Configuring aws"
aws configure
echo "Checking if gscloud exists"
gsutil ls

status=$?

if test $status -eq 0
then
    echo "gscloud is present on this machine. Skipping install step"
else
    echo "Installing gscloud cli"
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-400.0.0-linux-x86_64.tar.gz
    tar -xf google-cloud-cli-400.0.0-linux-x86_64.tar.gz 
    ./google-cloud-sdk/install.sh
fi


echo "installing SDK for gscloud"
# curl https://sdk.cloud.google.com | bash
echo "checking if gsutil is working"
gsutil ls gs://
gsutil cp -r gs://${gc_bucketname} s3://${aws_bucketname}