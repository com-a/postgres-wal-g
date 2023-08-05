#!/bin/bash
$(echo  wal-g backup-list ) >/tmp/bukup_list

if [ ! -s /tmp/bukup_list ]; then
    sed -i -e 's/#restore_command = '\'''\''/restore_command = '\''wal-g wal-fetch "%f" "%p"'\''/g' /var/lib/postgresql/data/postgresql.conf

    sed -i -e 's/#archive_mode = off/archive_mode = on/g' /var/lib/postgresql/data/postgresql.conf
    sed -i -e 's/#archive_command = '\'''\''/archive_command = '\''wal-g wal-push %p'\''/g' /var/lib/postgresql/data/postgresql.conf
    sed -i -e 's/#archive_timeout = 0/archive_timeout = 60/g' /var/lib/postgresql/data/postgresql.conf
    sed -i -e 's/#wal_level = replica/wal_level = replica/g' /var/lib/postgresql/data/postgresql.conf

fi

env >> /tmp/crontab
echo "0 5 * * * wal-g backup-push /var/lib/postgresql/data" >> /tmp/crontab
crontab  /tmp/crontab