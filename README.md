Image extending [tozd/mongodb](https://github.com/tozd/docker-mongodb) image to use
it with [tozd/meteor](https://github.com/tozd/docker-meteor) based images.

Different branches/tags provide different MongoDB versions.

The intended use of this image is that it is run alongside the `tozd/meteor` based image.
You should volume mount the same `run.settings` configuration file into both Meteor app container
and the container from this image. This image automatically creates the database
and accounts with provided passwords, and creates a simple replica set with oplog.

Example of a `/etc/service/mongod/run.settings` file:

```bash
MONGODB_ADMIN_PWD='<pass>'
MONGODB_CREATE_PWD='<pass>'
MONGODB_OPLOGGER_PWD='<pass>'

export MONGO_URL="mongodb://meteor:${MONGODB_CREATE_PWD}@mongodb/meteor"
export MONGO_OPLOG_URL="mongodb://oplogger:${MONGODB_OPLOGGER_PWD}@mongodb/local?authSource=admin"
```

The `export` lines are not necessary for this image, but are used by `tozd/meteor` based images.
