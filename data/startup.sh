#!/usr/bin/env bash


$(echo  wal-g backup-list ) >/tmp/bukup_list

if [ -s /tmp/bukup_list ]; then
#データがある場合の処理
    rm -rf /var/lib/postgresql/data/*
    wal-g backup-fetch /var/lib/postgresql/data LATEST
    touch "/var/lib/postgresql/data/recovery.signal"
fi

docker-entrypoint.sh $@
