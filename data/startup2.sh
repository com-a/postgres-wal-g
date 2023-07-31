#!/usr/bin/env bash
$(echo  wal-g backup-list ) >/tmp/bukup_list

docker-entrypoint.sh $@


#exec "$@"