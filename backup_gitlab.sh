#!/bin/bash

#
# Bundle together a Gitlab backup, a Gitlab /etc/gitlab backup and copying the files off to a
#  remote destination.
#
# Run once weekly on Sunday at midnight by inserting the following into crontab for root:
#  0 0 * * 0 /root/cron/backup_gitlab.sh
#

export GOOGLE_APPLICATION_CREDENTIALS="/root/MY-GOOGLE-KEYFILE.json"

# Our hostname
bk_host=`/bin/hostname`

# Backup date
bk_date=`/bin/date --iso-8601`

# Backup destination directory
bk_dest_root=/net/ddn/backup2/gitlab.backups
bk_dest_dir=${bk_dest_root}/${bk_date}

# Backup name to pass to gitlab-backup
bk_name=${bk_host}_${bk_date}

# Run the Gitlab backup
/usr/bin/gitlab-backup create STRATEGY=copy BACKUP=$bk_name CRON=1
gitlab_backup_file=/var/opt/gitlab/backups/${bk_name}_gitlab_backup.tar

# Run the Gitlab /etc/gitlab backup
gitlab_etc_backup_file=/tmp/${bk_name}_gitlab_etc_backup.tar
/bin/tar -c -p -f $gitlab_etc_backup_file /etc/gitlab >/dev/null 2>&1

# Copy data to the backup destination
/bin/mkdir -p $bk_dest_dir
/bin/cp $gitlab_backup_file $bk_dest_dir
/bin/cp $gitlab_etc_backup_file $bk_dest_dir

# Make another copy of the data to the cloud
/usr/bin/gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
/usr/bin/gsutil cp -r $bk_dest_dir gs://git1-backups

# Clean up
/bin/rm -rf $gitlab_backup_file
/bin/rm -rf $gitlab_etc_backup_file

