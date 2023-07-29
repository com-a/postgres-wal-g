
#!/bin/bash
wget -P /tmp https://github.com/wal-g/wal-g/releases/download/v0.2.19/wal-g.linux-amd64.tar.gz
tar -C /usr/local/bin -xvf wal-g.linux-amd64.tar.gz
chown postgres:postgres /usr/local/bin/wal-g

sed -i -e 's/#restore_command = '\'''\''/restore_command = '\''wal-g wal-fetch %f %p'\''/g' /var/lib/postgresql/data/postgresql.conf

sed -i -e 's/#archive_mode = off/archive_mode = on/g' /var/lib/postgresql/data/postgresql.conf
sed -i -e 's/#archive_command = '\'''\''/archive_command = '\''wal-g wal-push %p'\''/g' /var/lib/postgresql/data/postgresql.conf
sed -i -e 's/#archive_timeout = 0/archive_timeout = 60/g' /var/lib/postgresql/data/postgresql.conf
sed -i -e 's/#wal_level = replica/wal_level = replica/g' /var/lib/postgresql/data/postgresql.conf

pg_ctl -D /var/lib/postgresql/data -w reload
rm /docker-entrypoint-initdb.d/setup.sh

touch "/var/lib/postgresql/data/recovery.signal"
wal-g backup-push /var/lib/postgresql/data/
