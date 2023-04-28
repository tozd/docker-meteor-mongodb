#!/bin/sh

set -e

cleanup_docker() {
  echo "Stopping Docker image"
  docker stop test
}

cleanup_config() {
  rm -f run.config
}

echo "Preparing"
apk add --no-cache mongodb-tools

echo "MONGODB_ADMIN_PWD='test'" > run.config
echo "MONGODB_CREATE_PWD='test'" >> run.config
echo "MONGODB_OPLOGGER_PWD='test'" >> run.config
trap cleanup_config EXIT

echo "Running Docker image"
docker run -d --name test --rm -p 27017:27017 -v "$(pwd)/run.config:/etc/service/mongod/run.config" "${CI_REGISTRY_IMAGE}:${TAG}"
trap cleanup_docker EXIT

echo "Sleeping"
sleep 20

echo "Testing"
nc -z docker 27017
mongostat -u admin -p test --authenticationDatabase=admin -n 1 --host docker