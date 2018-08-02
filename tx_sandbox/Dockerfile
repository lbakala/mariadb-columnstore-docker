# vim:set ft=dockerfile:
FROM mariadb:10.3

ARG root_pass=secret_pass
ENV MYSQL_ROOT_PASSWORD=$root_pass

ARG user=sandbox
ENV MYSQL_USER=$user

ARG pass=highlyillogical
ENV MYSQL_PASSWORD=$pass

ARG db=bookstore
ENV MYSQL_DATABASE=$db

RUN mkdir -p /tmp/bookstore
RUN mkdir -p /tmp/bookstore/csv
RUN apt-get update; \
	apt-get -y install curl;
RUN curl https://downloads.mariadb.com/sample-data/sandbox15mr.tar.gz --output /tmp/bookstore/csv/bookstore.tar.gz
RUN tar -vxzf /tmp/bookstore/csv/bookstore.tar.gz --directory /tmp/bookstore/csv/
RUN sed -i 's/%CSV%/\/tmp\/bookstore\/csv\//g' /tmp/bookstore/csv/load_tx_template.sql
RUN sed -i 's/%DB%/bookstore/g' /tmp/bookstore/csv/load_tx_template.sql
RUN cp /tmp/bookstore/csv/load_tx_template.sql /docker-entrypoint-initdb.d/load_tx_data.sql