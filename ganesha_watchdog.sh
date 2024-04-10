#!/bin/bash

#
# Restart the Ganesha NFS server if logs imply that it might be hung.
#

GANESHA_LOG=/var/log/ganesha/ganesha.log

if /usr/bin/tail $GANESHA_LOG | /bin/grep -q "status is unhealthy"; then
  /usr/sbin/service nfs-ganesha restart
fi

if /usr/bin/tail $GANESHA_LOG | /bin/grep -q "Not a replay request"; then
  /usr/sbin/service nfs-ganesha restart
fi
