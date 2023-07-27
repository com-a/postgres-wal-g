FROM postgres:14


RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    apt-get install -y vim less wget




#ENV AWS_S3_FORCE_PATH_STYLE "true"
ENV PGPORT "5432"
ENV PGHOST "/var/run/postgresql"
ENV WALG_COMPRESSION_METHOD "lz4"



RUN wget https://github.com/wal-g/wal-g/releases/download/v0.2.19/wal-g.linux-amd64.tar.gz
RUN tar -C /usr/local/bin -xvf wal-g.linux-amd64.tar.gz
RUN chown postgres:postgres /usr/local/bin/wal-g
COPY ./data/archive.sh /docker-entrypoint-initdb.d/
COPY ./data/startup.sh /tmp/startup.sh

CMD sh /tmp/startup.sh

USER postgres


