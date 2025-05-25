#!/bin/bash
set -e

IMAGE_TAG="#{BuildVariables.IMAGE_TAG}"
AWS_ACCOUNT_ID="#{BuildVariables.AWS_ACCOUNT_ID}"
AWS_REGION="#{BuildVariables.AWS_REGION}"
APP_NAME="#{BuildVariables.APP_NAME}"

IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$APP_NAME:$IMAGE_TAG"

echo "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Pulling image: $IMAGE_URI"
docker pull $IMAGE_URI
docker stop $APP_NAME || true
docker rm $APP_NAME || true
docker run -d --name $APP_NAME -p 80:80 $IMAGE_URI
