# files-backup-s3
Backup files to S3 (supports periodic backups). Based on https://github.com/schickling/dockerfiles/tree/master/mysql-backup-s3 .

## Basic usage

```sh
$ docker run -e S3_ACCESS_KEY_ID=key -e S3_SECRET_ACCESS_KEY=secret -e S3_BUCKET=bucket -e S3_PREFIX=backup -v ./path-to-files-to-backup:/backup/:ro prihlop/files-backup-s3
```

## Environment variables

- `S3_ACCESS_KEY_ID` your AWS access key *required*
- `S3_SECRET_ACCESS_KEY` your AWS secret key *required*
- `S3_BUCKET` your AWS S3 bucket path *required*
- `S3_PREFIX` path prefix in your bucket (default: 'backup')
- `S3_FILENAME` a consistent filename to overwrite with your backup.  If not set will use a timestamp.
- `S3_FILEPREFIX` a file prefix to add to filename (for example: S3_FILEPREFIX.timestamp.files.tar.gz)
- `S3_REGION` the AWS S3 bucket region (default: us-west-1)
- `S3_ENDPOINT` the AWS Endpoint URL, for S3 Compliant APIs such as [minio](https://minio.io) (default: none)
- `S3_S3V4` set to `yes` to enable AWS Signature Version 4, required for [minio](https://minio.io) servers (default: no)
- `SCHEDULE` backup schedule time, see explainatons below

## Docker-compose usage example

```
version: 3

services:
  files-backup-s3:
    image: prihlop/files-backup-s3
    environment:
      AWS_ACCESS_KEY_ID: 'key'
      AWS_SECRET_ACCESS_KEY: 'secret'
      AWS_DEFAULT_REGION: 'eu-west-1'
      S3_BUCKET: 'backet'
      S3_PREFIX: 'dir/subdir'
      S3_FILEPREFIX: 'uploads'
      SCHEDULE: '0 0 1 * * *'
    volumes:
      - ./path-to-files-to-backup:/backup/:ro
```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.


