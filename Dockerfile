FROM postgres:14

#ENV AWS_S3_FORCE_PATH_STYLE "true"
ENV PGPORT "5432"
ENV PGHOST "/var/run/postgresql"
ENV WALG_COMPRESSION_METHOD "lz4"

COPY ./data/setup.sh /docker-entrypoint-initdb.d/

USER postgres


