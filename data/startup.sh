#!/usr/bin/env bash


$(echo  wal-g backup-list ) >/tmp/bukup_list

if [ -s /tmp/bukup_list ]; then
#データがある場合の処理
    rm -rf /var/lib/postgresql/data/*
    wal-g backup-fetch /var/lib/postgresql/data LATEST
    #sleep 30
    rm /var/lib/postgresql/data/backup_label
    #rm /var/lib/postgresql//data/backup_label/tablespace_map
    touch "/var/lib/postgresql/data/recovery.signal"
    
fi


docker-entrypoint.sh $@

<<COMMENT_OUT
if [ ! -s /tmp/bukup_list ]; then
#空の場合の処理
    sed -i -e s/#restore_command = '\''/restore_command = 'wal-g wal-fetch "%f" "%p"'\''/g' /var/lib/postgresql/data/postgresql.conf

    sed -i -e 's/#archive_mode = off/archive_mode = on/g' /var/lib/postgresql/data/postgresql.conf
    sed -i -e 's/#archive_command = '\'''\''/archive_command = '\''wal-g wal-push %p'\''/g' /var/lib/postgresql/data/postgresql.conf
    sed -i -e 's/#archive_timeout = 0/archive_timeout = 60/g' /var/lib/postgresql/data/postgresql.conf
    sed -i -e 's/#wal_level = replica/wal_level = replica/g' /var/lib/postgresql/data/postgresql.conf

    pg_ctl -D /var/lib/postgresql/data -w reload
    wal-g backup-push /var/lib/postgresql/data/
fi
COMMENT_OUT


