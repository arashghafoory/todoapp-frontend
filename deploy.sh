#!/bin/bash
set -e

APP_NAME="todo-frontend"
AWS_ACCOUNT_ID="706712229921"
AWS_REGION="us-east-1"
IMAGE_TAG=$(cat /home/ec2-user/app/imageTag.env | cut -d '=' -f2)

IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/todoapp/frontend:$IMAGE_TAG"

echo "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Pulling image: $IMAGE_URI"
docker pull $IMAGE_URI

echo "Stopping old container..."
docker stop $APP_NAME || true
docker rm $APP_NAME || true

echo "Running new container..."
docker run -d --name $APP_NAME -p 80:80 $IMAGE_URI
