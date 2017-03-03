#!/bin/bash -e

# An example script to run MongoDB for Meteor in production. It uses data volumes under the $DATA_ROOT directory.
# By default /srv.

NAME='mongodb'
DATA_ROOT='/srv'
MONGODB_DATA="${DATA_ROOT}/${NAME}/data"
MONGODB_LOG="${DATA_ROOT}/${NAME}/log"

# This file is used by both Meteor app and tozd/meteor-mongodb images. The latter automatically creates the
# database and accounts with provided passwords. The file should look like:
#
# MONGODB_ADMIN_PWD='<pass>'
# MONGODB_CREATE_PWD='<pass>'
# MONGODB_OPLOGGER_PWD='<pass>'
#
# export MONGO_URL="mongodb://meteor:${MONGODB_CREATE_PWD}@mongodb/meteor"
# export MONGO_OPLOG_URL="mongodb://oplogger:${MONGODB_OPLOGGER_PWD}@mongodb/local?authSource=admin"
CONFIG="${DATA_ROOT}/${NAME}/run.config"

mkdir -p "$MONGODB_DATA"
mkdir -p "$MONGODB_LOG"

touch "$CONFIG"

if [ ! -s "$CONFIG" ]; then
  echo "Set MONGODB_CREATE_PWD, MONGODB_ADMIN_PWD, MONGODB_OPLOGGER_PWD environment variables in '$CONFIG'."
  exit 1
fi

docker stop "${NAME}" || true
sleep 1
docker rm "${NAME}" || true
sleep 1
docker run --detach=true --restart=always --name "${NAME}" --volume "${CONFIG}:/etc/service/mongod/run.config" --volume "${MONGODB_LOG}:/var/log/mongodb" --volume "${MONGODB_DATA}:/var/lib/mongodb" tozd/meteor-mongodb:2.6
