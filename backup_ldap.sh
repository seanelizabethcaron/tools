#!/bin/bash

#
# Back up LDAP cn=config and accounts databases
#
# Run once weekly on Sunday at midnight by inserting the following into crontab for root:
#  0 0 * * 0 /root/cron/backup_ldap.sh
#

export GOOGLE_APPLICATION_CREDENTIALS="/root/MY-GOOGLE-KEYFILE.json"
export GPG_SECRET="/root/.gpg-secret"

# Our hostname
bk_host=`/bin/hostname`

# Backup date
bk_date=`/bin/date --iso-8601`

# Backup destination directory
bk_dest_root=/net/ddn/backup4/ldap.backups
bk_dest_dir=${bk_dest_root}/${bk_date}

# Backup name
bk_name=${bk_host}_${bk_date}

# Run the config backup and encrypt it
config_backup_file=/tmp/${bk_name}_config_backup.ldif
/usr/sbin/slapcat -n 0 > $config_backup_file >/dev/null 2>&1
cat $GPG_SECRET | /usr/bin/gpg -c --passphrase-fd 0 --batch --yes $config_backup_file

# Run the data backup and encrypt it
data_backup_file=/tmp/${bk_name}_data_backup.ldif
/usr/sbin/slapcat -n 1 > $data_backup_file >/dev/null 2>&1
cat $GPG_SECRET | /usr/bin/gpg -c --passphrase-fd 0 --batch --yes $data_backup_file

# Copy data to the backup destination
/bin/mkdir -p $bk_dest_dir
/bin/cp $config_backup_file.gpg $bk_dest_dir
/bin/cp $data_backup_file.gpg $bk_dest_dir

# Make another copy of the data to the cloud
/usr/bin/gcloud auth activate-service-account --key-file /root/MY-GOOGLE-KEYFILE.json
/usr/bin/gsutil cp -r $bk_dest_dir gs://ldap-backups

# Clean up
/bin/rm -rf $config_backup_file
/bin/rm -rf $data_backup_file
