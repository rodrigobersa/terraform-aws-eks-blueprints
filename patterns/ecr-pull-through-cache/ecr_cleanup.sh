#!/bin/bash

while [ -z "${ECR_REGION// }" ]; do
  echo "Inform the region in which the Amazon ECR resides: "
  read ECR_REGION
done

PREFIXES=(
    "docker-hub/"
    "ecr/"
    "k8s/"
    "quay/"
)

REPOS=$(aws ecr describe-repositories --query 'repositories[*].repositoryName' --output text --region ${ECR_REGION})

for repo in ${REPOS}; do
    for prefix in "${PREFIXES[@]}"; do
        if [[ $repo == $prefix* ]]; then
            echo "Deleting repository: ${repo}"
            aws ecr delete-repository --repository-name ${repo} --region ${ECR_REGION} --force
        fi
    done
done