#!/bin/sh

set -e

cleanup_docker=0
cleanup_config=0
cleanup() {
  if [ "$cleanup_docker" -ne 0 ]; then
    echo "Stopping Docker image"
    docker stop test
  fi

  if [ "$cleanup_config" -ne 0 ]; then
    rm -f run.config
  fi
}

trap cleanup EXIT

echo "Preparing"
apk add --no-cache mongodb-tools

echo "MONGODB_ADMIN_PWD='test'" > run.config
echo "MONGODB_CREATE_PWD='test'" >> run.config
echo "MONGODB_OPLOGGER_PWD='test'" >> run.config
cleanup_config=1

echo "Running Docker image"
docker run -d --name test --rm -p 27017:27017 -v "$(pwd)/run.config:/etc/service/mongod/run.config" "${CI_REGISTRY_IMAGE}:${TAG}"
cleanup_docker=1

echo "Sleeping"
sleep 20

echo "Testing"
nc -z docker 27017
# New mongostat does not work with MongoDB 2.4. It fails to authenticate.
if [ "$TAG" != "2.4" ]; then
  mongostat -u admin -p test --authenticationDatabase=admin -n 1 --host docker
fi
