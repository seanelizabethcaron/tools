tools
-----

Sean Caron <scaron@umich.edu>

A collection of useful systems administration tools and scripts too small to justify their own repository.

#### addslurmusers.pl

Add a list of users back to the Slurm accounting system given a dump of the output of ```sacctmgr show user``` from a previous Slurm installation.

#### afsmigrate.pl

Given a list of AFS volumes, migrate them from source server and partition to destination server and partition.

#### backup_gitlab.sh

Wraps up all steps required to perform a full Gitlab backup to a configured destination and to the cloud.

#### backup_puppet.sh

Wraps up all steps required to perform a Puppet master server backup to a configured destination and to the cloud.

#### beacon.go

Light error LEDs on drives in JBOD cabinets.

Build with:

```
go build beacon.go
```

#### beacon_off.sh

Deactivate error LED on all attached JBOD drives.

#### beacon_on.sh

Activate error LED on all attached JBOD drives.

#### blockddos.sh

Identify and block subnets performing trivial DDoS attacks on a targeted service.

#### checkarray

Modified version of the Linux md RAID checkarray script that permits limiting checks to only even or odd arrays.

#### check_ldap_server.py

Watchdog script to ensure slapd is running, otherwise restart slapd.

#### checksmartall.sh

Dump SMART health status for all attached drives.

#### checksmartdetailed.sh

Dump detailed SMART health status for all attached drives. 

#### dedupe.py

Deduplicate lines in a text file

#### dnsseq.go

Automates the generation of long sequences of DNS A-records and PTR-records.

Build with:

```
go build dnsseq.go
```

#### du_report.sh

Use this as a cron job to send monthly disk utilization reports for configured volumes to a configured user.

#### ganesha_watchdog.sh

Restart Ganesha NFS server if log entries imply that it may be hung.

#### getcampusuid

Use this to get the UID number associated with a U-M campus uniqname.

#### install.R

Install large numbers of R packages from a list.

#### nodeinfo

Add this to a Slurm job script to print some node hardware information to the job log for profiling and benchmarking purposes.

#### pkgsinrepo.pl

Checks presence-in-repository status of all Package resources in a Puppet manifest.

#### mdfinddrives.sh

Find all drives that should be members of a given MD RAID array.

#### mdfindunused.sh

Find all drives that are not a member of any MD RAID array.

#### mongobackup.sh

Simple MongoDB backup script with rotation to be used as a cron job.

#### plvc.py

Compare version of installed Python library reported by pip with a version number specified on the command line.

#### purgepackages.sh

Automatically purge a list of packages in Linux distributions that use apt style package management.

Input should be a file containing a list of packages, one package per line, prepped using a command similar to the following:

```
dpkg --get-selections | grep -v deinstall | cut -f 1 > purgepackages.list
```
#### purge_old_globus.pl

Quick and dirty script to clean up old Globus Connect Server v4 packages on systems that have been migrated to v5.

#### pwgen.go

Generate random password strings.

Build with:

```
go build pwgen.go
```

#### remote_user.py

Drop this into cgi-bin to show what SSO is reporting for $REMOTE_USER.

#### requeueheldslurm.pl

Release all jobs held in the Slurm queue stuck in launch failed requeued held state.

#### selections2manifest.pl

Convert a list of packages in ```dpkg --get-selections``` format to a basic list of Package resources in a Puppet manifest.

Input should be a file containing a list of packages, one package per line, prepped using a command similar to the following:

```
dpkg --get-selections | grep -v deinstall | cut -f 1 > input.selections
```

#### setup_sftp_chroot.pl

Create sshd_config directives for a list of chroot user accounts previously using the scponlyc shell mechanism.

#### slurm_node_trouble_report.pl

Insert into cron to send an email report of all Slurm nodes in DOWN or DRAIN states.

#### zerodrives.sh

Clear MD RAID superblock and zero a small initial extent of all attached JBOD drives.

