#
/usr/lib/postgresql/14/bin/pg_ctl -D "/var/lib/postgresql/data"  -m fast -w stop

if [ ! -d /var/lib/postgresql/data ]; then
  wal-g backup-fetch /var/lib/postgresql/data/ LATEST
else
  touch /var/lib/pgsql/data/recovery.signal
fi


/usr/lib/postgresql/14/bin/pg_ctl -D "/var/lib/postgresql/data" -w start
