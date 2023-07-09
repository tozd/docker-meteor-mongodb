#!/bin/sh

set -e

cleanup_docker=0
cleanup_mongo=0
cleanup_app=0
cleanup_image=0
cleanup_config=0
cleanup() {
  if [ "$cleanup_docker" -ne 0 ]; then
    echo "Stopping Docker image"
    docker stop test
  fi

  if [ "$cleanup_mongo" -ne 0 ]; then
    echo "Stopping MongoDB"
    docker stop mongotest
  fi

  if [ "$cleanup_app" -ne 0 ]; then
    echo "Removing test app"
    rm -rf test
  fi

  if [ "$cleanup_image" -ne 0 ]; then
    echo "Removing Docker image"
    docker image rm -f testimage
  fi

  if [ "$cleanup_config" -ne 0 ]; then
    rm -f run.config
  fi
}

trap cleanup EXIT

echo "Preparing"
apk add --no-cache git mongodb-tools

echo "MONGODB_ADMIN_PWD='test'" > run.config
echo "MONGODB_CREATE_PWD='test'" >> run.config
echo "MONGODB_OPLOGGER_PWD='test'" >> run.config
echo 'export MONGO_URL="mongodb://meteor:${MONGODB_CREATE_PWD}@mongotest/meteor"' >> run.config
echo 'export MONGO_OPLOG_URL="mongodb://oplogger:${MONGODB_OPLOGGER_PWD}@mongotest/local?authSource=admin"' >> run.config
cleanup_config=1

echo "Running MongoDB"
docker run -d --name mongotest --rm -p 27017:27017 -v "$(pwd)/run.config:/etc/service/mongod/run.config" "${CI_REGISTRY_IMAGE}:${TAG}"
cleanup_mongo=1

echo "Sleeping"
sleep 20

echo "Testing"
nc -z docker 27017
# New mongostat does not work with MongoDB 2.4. It fails to authenticate.
if [ "$TAG" != "2.4" ]; then
  mongostat -u admin -p test --authenticationDatabase=admin -n 1 --host docker
fi

echo "Creating test app"
git clone https://github.com/meteor/clock test
cleanup_app=1

if [ "$TAG" = "2.4" ]; then
  METEOR_VERSION="0.9.3"
  git -C test checkout --quiet ec6a8c53733ac49fda92ddf97c54f764c1bbfc92
elif [ "$TAG" = "2.6" ]; then
  METEOR_VERSION="1.0.4.2"
  git -C test checkout --quiet 8cde5f42ec6bb926be961c21114e866009940df2
elif [ "$TAG" = "3.2" ]; then
  METEOR_VERSION="1.4.0.1"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
elif [ "$TAG" = "3.4" ]; then
  METEOR_VERSION="1.6.1.1"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime@7.0.0-beta.55
elif [ "$TAG" = "3.6" ]; then
  METEOR_VERSION="1.7.0.5"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime@7.0.0-beta.55
elif [ "$TAG" = "4.0" ]; then
  METEOR_VERSION="1.8.0.2"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime@7.0.0-beta.55
elif [ "$TAG" = "4.2" ]; then
  METEOR_VERSION="1.11.1"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime
elif [ "$TAG" = "4.4" ]; then
  METEOR_VERSION="2.2.1"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime
elif [ "$TAG" = "5.0" ]; then
  METEOR_VERSION="2.8.1"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime
elif [ "$TAG" = "6.0" ]; then
  METEOR_VERSION="2.11.0"
  echo "{}" > "test/package.json"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor update --release "$METEOR_VERSION"
  time docker run --rm --entrypoint '' --volume "$(pwd)/test:/app" --workdir /app --env NODE_TLS_REJECT_UNAUTHORIZED=0 "registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" meteor npm install --save @babel/runtime
else
  echo "$TAG not supported for testing"
  exit 1
fi

echo "Building Docker image"
echo "FROM registry.gitlab.com/tozd/docker/meteor:ubuntu-focal-${METEOR_VERSION}" > test/Dockerfile
time docker build -t testimage -f test/Dockerfile --build-arg NODE_TLS_REJECT_UNAUTHORIZED=0 test
cleanup_image=1

echo "Running Docker image"
docker run -d --name test --rm -p 3000:3000 -v "$(pwd)/run.config:/etc/service/meteor/run.config" --link mongotest:mongotest testimage
cleanup_docker=1

# It is OK to sleep just for 10 seconds because Meteor Docker image knows how to wait for MongoDB to become ready.
echo "Sleeping"
sleep 10

echo "Testing"
wget -T 30 -q -O - http://docker:3000 | grep -q '<title>SVG Clock Demo</title>'
