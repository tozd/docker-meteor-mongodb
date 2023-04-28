# tozd/meteor-mongodb

<https://gitlab.com/tozd/docker/meteor-mongodb>

Available as:

- [`tozd/meteor-mongodb`](https://hub.docker.com/r/tozd/meteor-mongodb)
- [`registry.gitlab.com/tozd/docker/meteor-mongodb`](https://gitlab.com/tozd/docker/meteor-mongodb/container_registry)

## Image inheritance

[`tozd/base`](https://gitlab.com/tozd/docker/base) ← [`tozd/runit`](https://gitlab.com/tozd/docker/runit) ← [`tozd/mongodb`](https://gitlab.com/tozd/docker/mongodb) ← `tozd/meteor-mongodb`

## Tags

- `2.4`: MongoDB 2.4
- `2.6`: MongoDB 2.6
- `3.2`: MongoDB 3.2
- `3.4`: MongoDB 3.4
- `3.6`: MongoDB 3.6
- `4.0`: MongoDB 4.0
- `4.2`: MongoDB 4.2
- `4.4`: MongoDB 4.4
- `5.0`: MongoDB 5.0
- `6.0`: MongoDB 6.0

## Variables

- `MONGODB_ADMIN_PWD`: Password for `admin` account the container creates on the first startup.
- `MONGODB_CREATE_PWD`: Password for `meteor` account the container creates on the first startup.
- `MONGODB_OPLOGGER_PWD`: Password for `oplogger` account the container creates on the first startup.

## Description

Image extending [tozd/mongodb](https://gitlab.com/tozd/docker/mongodb) image to use
it with [tozd/meteor](https://gitlab.com/tozd/docker/meteor) based images.

Different Docker tags provide different MongoDB versions.

The intended use of this image is that it is run alongside the `tozd/meteor` based image.
You should volume mount the same `run.config` configuration file into both Meteor app container
and the container from this image. The container on the first startup automatically creates
the database and accounts with provided passwords, and creates a simple replica set with oplog.

Example of a `/etc/service/mongod/run.config` file:

```bash
MONGODB_ADMIN_PWD='<pass>'
MONGODB_CREATE_PWD='<pass>'
MONGODB_OPLOGGER_PWD='<pass>'

export MONGO_URL="mongodb://meteor:${MONGODB_CREATE_PWD}@mongodb/meteor"
export MONGO_OPLOG_URL="mongodb://oplogger:${MONGODB_OPLOGGER_PWD}@mongodb/local?authSource=admin"
```

The `export` lines are not necessary for this image, but are used by `tozd/meteor` based images.
