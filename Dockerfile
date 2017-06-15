FROM node:alpine
MAINTAINER matthew.ceroni@smarsh.com

#
# install mongo tools
#
RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache mongodb-tools py2-pip \
    && pip install pymongo awscli

#
# AWS Access Key
# (not needed if running inside AWS with attached IAM role)
ENV AWS_ACCESS_KEY=

#
# AWS Secret Access Key
# (not needed if running inside AWS with attached IAM role)
ENV AWS_SECRET_ACCESS_KEY=

ENV MONGO_URI=
#
# do a complete database backup
#
ENV MONGO_COMPLETE=true

#
# schedule to run backup at (12:00 am)
#
ENV BACKUP_SCHEDULE="0 0 * * *"

#
# S3 bucket + path to upload backups to
#
ENV S3_BUCKET=
ENV S3_PATH="dbbackup"

#
# copy helper scripts
#
COPY scripts /scripts
COPY docker-entrypoint.sh /

#
# Set the entrypoint command
#
ENTRYPOINT [ "/docker-entrypoint.sh" ]
