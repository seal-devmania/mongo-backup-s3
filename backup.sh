#!/bin/bash
set -e

: "${MONGO_URI:?}"
: "${MONGO_ARGS:?}"
: "${S3_BUCKET:?}"
: "${S3_ARGS:?}"
: "${AWS_ACCESS_KEY_ID:?}"
: "${AWS_SECRET_ACCESS_KEY:?}"
: "${DATE_FORMAT:?}"
: "${FILE_PREFIX:?}"

FOLDER=/backup
DUMP_OUT=dump

FILE_NAME="${FILE_PREFIX}$(date -u +"${DATE_FORMAT}").tar.gz"
FILE_NAME_LATEST="${FILE_PREFIX}latest.tar.gz"

echo "Creating backup folder..."
rm -rf "${FOLDER}" && mkdir -p "${FOLDER}" && cd "${FOLDER}"

echo "Starting backup..."
mongodump --uri "${MONGO_URI}" ${MONGO_ARGS}

echo "Compressing backup..."
tar -czvf "${FILE_NAME}" "${DUMP_OUT}" && rm -rf "${DUMP_OUT}"

cp "${FILE_NAME}" "${FILE_NAME_LATEST}"

echo "Uploading backup to S3..."
aws s3 cp "${FILE_NAME}" "s3://${S3_BUCKET}/${FILE_NAME}" ${S3_ARGS}
aws s3 cp "${FILE_NAME_LATEST}" "s3://${S3_BUCKET}/${FILE_NAME_LATEST}" ${S3_ARGS}

echo "Removing backup files..."
rm -f "${FILE_NAME}" "${FILE_NAME_LATEST}"

echo "Done!"
