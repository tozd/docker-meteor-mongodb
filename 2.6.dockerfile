FROM registry.gitlab.com/tozd/docker/mongodb:2.6

ENV MONGODB_ADMIN_PWD=
ENV MONGODB_CREATE_PWD=
ENV MONGODB_OPLOGGER_PWD=

COPY ./etc-2.6/service/mongod/run.initialization /etc/service/mongod/run.initialization
