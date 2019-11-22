#! /bin/sh

set -e

if [ "${AWS_ACCESS_KEY_ID}" == "**None**" ]; then
  echo "Warning: You did not set the AWS_ACCESS_KEY_ID environment variable."
fi

if [ "${AWS_SECRET_ACCESS_KEY}" == "**None**" ]; then
  echo "Warning: You did not set the AWS_SECRET_ACCESS_KEY environment variable."
fi

if [ "${AWS_BUCKET}" == "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

ARCHIVE_START_TIME=$(date +"%Y-%m-%dT%H%M%SZ")

copy_s3 () {
  SRC_FILE=$1
  DEST_FILE=$2

  if [ "${S3_ENDPOINT}" == "**None**" ]; then
    AWS_ARGS=""
  else
    AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
  fi

  echo "Uploading ${DEST_FILE} on S3..."

  cat $SRC_FILE | aws $AWS_ARGS s3 cp - s3://$S3_BUCKET/$S3_PREFIX/$DEST_FILE

  if [ $? != 0 ]; then
    >&2 echo "Error uploading ${DEST_FILE} on S3"
  fi

  rm $SRC_FILE
}

echo "Creating archive..."

ARCHIVE_FILE="/tmp/backup.tar.gz"
tar -czf $ARCHIVE_FILE /backup/*

if [ $? == 0 ]; then
  if [ "${S3_FILENAME}" == "**None**" ]; then
    S3_FILE="${ARCHIVE_START_TIME}.files.tar.gz"
  else
    S3_FILE="${S3_FILENAME}.tar.gz"
  fi

  if [ "${S3_FILEPREFIX}" == "**None**" ]; then
  continue
  else
    S3_FILE="${S3_FILEPREFIX}.${S3_FILE}"
  fi

  copy_s3 $ARCHIVE_FILE $S3_FILE
else
  >&2 echo "Error creating backup"
fi

echo "Files backup finished"
