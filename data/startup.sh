#!/usr/bin/env bash
$(echo  wal-g backup-list ) >/tmp/bukup_list_startup
chown postgres:postgres /tmp/bukup_list


if [ -s /tmp/bukup_list_startup ]; then
#データがある場合の処理
    rm -rf /var/lib/postgresql/data/*
    wal-g backup-fetch /var/lib/postgresql/data LATEST
    #sleep 30
    touch "/var/lib/postgresql/data/recovery.signal"
    
fi

#env >> /tmp/crontab
echo "*/3 * * * * sh /backup.sh" >> /tmp/crontab
crontab /tmp/crontab

/usr/local/bin/docker-entrypoint.sh postgres
