FROM registry.gitlab.com/tozd/docker/mongodb:3.2

ENV MONGODB_ADMIN_PWD=
ENV MONGODB_CREATE_PWD=
ENV MONGODB_OPLOGGER_PWD=

COPY ./etc-3.2/service/mongod/run.initialization /etc/service/mongod/run.initialization
