FROM postgres:14


RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    apt-get install -y vim less wget cron


#ENV AWS_S3_FORCE_PATH_STYLE "true"
ENV PGPORT "5432"
ENV PGHOST "/var/run/postgresql"
ENV WALG_COMPRESSION_METHOD "lz4"

RUN wget -P /tmp https://github.com/wal-g/wal-g/releases/download/v0.2.19/wal-g.linux-amd64.tar.gz
RUN tar -C /usr/local/bin -xvf /tmp/wal-g.linux-amd64.tar.gz
RUN chown postgres:postgres /usr/local/bin/wal-g

COPY ./data/setup.sh /docker-entrypoint-initdb.d/setup.sh
RUN chmod 775 /docker-entrypoint-initdb.d/setup.sh

COPY ./data/startup.sh /startup.sh
COPY ./data/backup.sh /backup.sh
RUN chmod 775 /*.sh


CMD [ "/startup.sh" ]
#USER postgres

