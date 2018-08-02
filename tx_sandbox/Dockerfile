# vim:set ft=dockerfile:
FROM mariadb:10.3

RUN mkdir -p /tmp/bookstore
RUN mkdir -p /tmp/bookstore/csv
RUN apt-get update; \
	apt-get -y install curl;
RUN curl https://dl.dropboxusercontent.com/s/ovt4bhaligvsutg/fmc4.tar.gz?dl=1 --output /tmp/bookstore/csv/bookstore.tar.gz
RUN tar -vxzf /tmp/bookstore/csv/bookstore.tar.gz --directory /tmp/bookstore/csv/
RUN sed -i 's/%CSV%/\/tmp\/bookstore\/csv\//g' /tmp/bookstore/csv/load_tx_template.sql
RUN sed -i 's/%DB%/bookstore/g' /tmp/bookstore/csv/load_tx_template.sql
RUN cp /tmp/bookstore/csv/load_tx_template.sql /docker-entrypoint-initdb.d/


