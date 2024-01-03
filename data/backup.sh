#!/bin/bash -l
/usr/local/bin/wal-g backup-push /var/lib/postgresql/data
/usr/local/bin/wal-g delete retain 1 --confirm
