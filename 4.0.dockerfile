FROM registry.gitlab.com/tozd/docker/mongodb:4.0

ENV MONGODB_ADMIN_PWD=
ENV MONGODB_CREATE_PWD=
ENV MONGODB_OPLOGGER_PWD=

COPY ./etc /etc
