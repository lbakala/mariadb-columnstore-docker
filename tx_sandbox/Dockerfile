FROM mariadb:10.3 as builder
ARG root_pass=secret_pass
ENV MYSQL_ROOT_PASSWORD=$root_pass

ARG user=sandbox
ENV MYSQL_USER=$user

ARG pass=highlyillogical
ENV MYSQL_PASSWORD=$pass

ARG db=bookstore
ENV MYSQL_DATABASE=$db

RUN mkdir -p /tmp/bookstore && \
	mkdir -p /tmp/bookstore/csv && \
	apt-get update && \
	apt-get -y install curl && \
	curl https://downloads.mariadb.com/sample-data/smallsb.tar --output /tmp/bookstore/csv/bookstore.tar && \
	tar -vxf /tmp/bookstore/csv/bookstore.tar --directory /tmp/bookstore/csv/ && \
	cd /tmp/bookstore/csv/ && \
	gunzip -v *.gz && \
	sed -i 's/%CSV%/\/tmp\/bookstore\/csv\//g' /tmp/bookstore/csv/load_tx_template.sql && \
	sed -i 's/%DB%/bookstore/g' /tmp/bookstore/csv/load_tx_template.sql && \
	cp /tmp/bookstore/csv/load_tx_template.sql /docker-entrypoint-initdb.d/load_tx_data.sql

RUN /bin/bash -c "/usr/bin/mysqld_safe --skip-grant-tables &" && \
	sleep 10 && \
	mysql -uroot -p$MYSQL_ROOT_PASSWORD < /tmp/bookstore/csv/load_tx_template.sql &&\
	ls -la /var/lib/mysql/bookstore && \
	killall mysqld_safe && \
	cp -a /var/lib/mysql /tmp/mysql

FROM mariadb:10.3

ARG root_pass=secret_pass
ENV MYSQL_ROOT_PASSWORD=$root_pass

ARG user=sandbox
ENV MYSQL_USER=$user

ARG pass=highlyillogical
ENV MYSQL_PASSWORD=$pass

ARG db=bookstore
ENV MYSQL_DATABASE=$db

COPY --from=builder /tmp/mysql /tmp/mysql/
RUN chown mysql:mysql --recursive /tmp/mysql/
COPY init.sh /docker-entrypoint-initdb.d
RUN chmod 755 /docker-entrypoint-initdb.d/init.sh

#Solution 1 slow
# COPY --from=builder /tmp/bookstore/csv /tmp/bookstore/csv/
# RUN ln -s /tmp/bookstore/csv/load_tx_template.sql /docker-entrypoint-initdb.d 

# Not working DB is initialise on start of the container
#COPY --from=builder /var/lib/mysql /var/lib/mysql/