#!/usr/bin/env bash
$(echo  wal-g backup-list ) >/tmp/bukup_list

if [ -s /tmp/bukup_list ]; then
#空の場合の処理
    rm -rf /var/lib/postgresql/data/*
    wal-g backup-fetch /var/lib/postgresql/data/ LATEST

    pg_ctl -D /var/lib/postgresql/data -w start
    pg_ctl -D /var/lib/postgresql/data -w stop
fi
exec "$@"