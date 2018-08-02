FROM mariadb/columnstore:latest

RUN mkdir -p /tmp/bookstore/csv
RUN curl https://downloads.mariadb.com/sample-data/sandbox15mr.tar.gz --output /tmp/bookstore/csv/bookstore.tar.gz
RUN tar -vxzf /tmp/bookstore/csv/bookstore.tar.gz --directory /tmp/bookstore/csv/
RUN sed -i 's/%CSV%/\/tmp\/bookstore\/csv\//g' /tmp/bookstore/csv/load_ax_template.sql
RUN sed -i 's/%DB%/bookstore/g' /tmp/bookstore/csv/load_ax_template.sql
RUN cp /tmp/bookstore/csv/load_ax_template.sql /docker-entrypoint-initdb.d/load_ax_data.sql
