FROM registry.gitlab.com/tozd/docker/mongodb:2.4

ENV MONGODB_ADMIN_PWD=
ENV MONGODB_CREATE_PWD=
ENV MONGODB_OPLOGGER_PWD=

COPY ./etc-2.4/service/mongod/run.initialization /etc/service/mongod/run.initialization
