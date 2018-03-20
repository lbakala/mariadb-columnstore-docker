FROM mariadb/columnstore_base:latest

RUN /install/postCfg.sh "1\ncolumnstore-1\n1\n1\n"

VOLUME /usr/local/mariadb/columnstore/etc
VOLUME /usr/local/mariadb/columnstore/data1
VOLUME /usr/local/mariadb/columnstore/local
VOLUME /usr/local/mariadb/columnstore/mysql/db
