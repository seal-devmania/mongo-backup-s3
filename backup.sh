#!/bin/bash

set -e

: ${MONGO_URI:?}
: ${MONGO_ARGS:?}
: ${S3_BUCKET:?}
: ${S3_ARGS:?}
: ${AWS_ACCESS_KEY_ID:?}
: ${AWS_SECRET_ACCESS_KEY:?}
: ${DATE_FORMAT:?}
: ${FILE_PREFIX:?}

FOLDER=/backup
DUMP_OUT=dump

FILE_NAME=${FILE_PREFIX}$(date -u +${DATE_FORMAT}).tar.gz

echo "Creating backup folder..."

rm -fr ${FOLDER} && mkdir -p ${FOLDER} && cd ${FOLDER}

echo "Starting backup..."

# mongodump --host=${MONGO_HOST} --db=${MONGO_DB} --out=${DUMP_OUT}

mongodump --uri "${MONGO_URI}" ${MONGO_ARGS}

echo "Compressing backup..."

tar -zcvf ${FILE_NAME} ${DUMP_OUT} && rm -fr ${DUMP_OUT}

echo "Uploading to S3..."

aws s3api put-object --bucket ${S3_BUCKET} --key ${FILE_NAME} --body ${FILE_NAME} ${S3_ARGS}

echo "Removing backup file..."

rm -f ${FILE_NAME}

echo "Done!"
