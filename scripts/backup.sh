#!/bin/sh

BKP_OPTIONS=`/scripts/mongouri.py`

# generate unique backup-name
BKP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC"

# check if dump location exists or not
if [ ! -d /dump ]; then
  echo "** creating /dump directory"
  mkdir /dump
fi

# run the actual backup
echo "** starting backup ${BKP_NAME}"

/usr/bin/mongodump ${BKP_OPTIONS} -o /dump/${BKP_NAME}

# compress the backup
cd /dump; tar -cvzf ${BKP_NAME}.tar.gz ${BKP_NAME}

# delete uncompressed backup
rm -rf ${BKP_NAME}

# copy the backup to S3
aws s3 cp ${BKP_NAME}.tar.gz "s3://${S3_BUCKET}/${S3_PATH}/"
