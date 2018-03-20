FROM mariadb/columnstore_base:latest

COPY setup.sh /root

RUN /install/postCfg.sh "1\ncolumnstore-1\n1\n1\n" && \
    /root/setup.sh

VOLUME /usr/local/mariadb/columnstore/etc
VOLUME /usr/local/mariadb/columnstore/data1
VOLUME /usr/local/mariadb/columnstore/local
VOLUME /usr/local/mariadb/columnstore/mysql/db
