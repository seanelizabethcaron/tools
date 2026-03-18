#!/bin/bash

#
# Back up critical files from a puppet master server.
#
# Run once weekly on Sunday at midnight by inserting the following into crontab for root:
#  0 0 * * 0 /root/cron/backup_puppet.sh
#

export GOOGLE_APPLICATION_CREDENTIALS="/root/MY-GOOGLE-KEYFILE.json"
export GPG_SECRET="/root/.gpg-secret"

# Our hostname
bk_host=`/bin/hostname`

# Backup date
bk_date=`/bin/date --iso-8601`

# Backup destination directory
bk_dest_root=/net/ddn/backup2/puppet.backups
bk_dest_dir=${bk_dest_root}/${bk_date}

# Backup name
bk_name=${bk_host}_${bk_date}

# Run the /etc backup
puppet_etc_backup_file=/tmp/${bk_name}_etc_backup.tar
/bin/tar -c -p -f $puppet_etc_backup_file /etc >/dev/null 2>&1
cat $GPG_SECRET | /usr/bin/gpg -c --passphrase-fd 0 --batch --yes $puppet_etc_backup_file

# Run the /opt backup
puppet_opt_backup_file=/tmp/${bk_name}_opt_backup.tar
/bin/tar -c -p --exclude=/opt/puppetlabs/server/data/puppetserver/reports -f $puppet_opt_backup_file /opt >/dev/null 2>&1
cat $GPG_SECRET | /usr/bin/gpg -c --passphrase-fd 0 --batch --yes $puppet_opt_backup_file

# Run the /root backup
puppet_root_backup_file=/tmp/${bk_name}_root_backup.tar
/bin/tar -c -p -f $puppet_root_backup_file /root >/dev/null 2>&1
cat $GPG_SECRET | /usr/bin/gpg -c --passphrase-fd 0 --batch --yes $puppet_root_backup_file

# Copy data to the backup destination
/bin/mkdir -p $bk_dest_dir
/bin/cp $puppet_etc_backup_file.gpg $bk_dest_dir
/bin/cp $puppet_opt_backup_file.gpg $bk_dest_dir
/bin/cp $puppet_root_backup_file.gpg $bk_dest_dir

# Make another copy of the data to the cloud
/usr/bin/gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
/usr/bin/gsutil cp -r $bk_dest_dir gs://puppet-backups

# Clean up
/bin/rm -rf $puppet_etc_backup_file
/bin/rm -rf $puppet_etc_backup_file.gpg
/bin/rm -rf $puppet_opt_backup_file
/bin/rm -rf $puppet_opt_backup_file.gpg
/bin/rm -rf $puppet_root_backup_file
/bin/rm -rf $puppet_root_backup_file
