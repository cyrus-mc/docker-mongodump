#!/bin/sh

# exit on any error
set +e

if [ -z ${BACKUP_SCHEDULE} ]; then
  echo "** scheduled backup not set, running backup immediately"
  /scripts/backup.sh
else
  echo "${BACKUP_SCHEDULE} /scripts/backup.sh" > /etc/crontabs/root
  # start cron in foreground
  exec crond -f -d 8 -L /dev/stdout
fi
