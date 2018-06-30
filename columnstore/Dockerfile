FROM centos:7

COPY mariadb-columnstore.repo runit.repo /etc/yum.repos.d/

# additional dependencies for docker image
RUN export USER=root && \
    /bin/echo "export USER=root" >> /root/.bashrc && \
    groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    yum -y install expect zlib rsyslog libaio boost file sudo libnl net-tools sysvinit-tools runit which psmisc lsof snappy rsync && \
    yum -y install mariadb-columnstore-client mariadb-columnstore-common mariadb-columnstore-libs mariadb-columnstore-platform mariadb-columnstore-server mariadb-columnstore-shared mariadb-columnstore-storage-engine && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN export USER=root && \
    /usr/bin/systemd-machine-id-setup && \
    /bin/echo -e "1\ncolumnstore-1\n1\n1\n" | /usr/local/mariadb/columnstore/bin/postConfigure && \
    /usr/local/mariadb/columnstore/mysql/bin/mysql --defaults-file=/usr/local/mariadb/columnstore/mysql/my.cnf -uroot -vvv -Bse "set sql_mode=NO_ENGINE_SUBSTITUTION;GRANT ALL ON *.* to root@'%';" && \
    /usr/local/mariadb/columnstore/bin/mcsadmin shutdownsystem y && \
    /usr/local/mariadb/columnstore/bin/mcsadmin resetAlarm ALL

COPY service /etc/service/
COPY runit_bootstrap /usr/sbin/
COPY dbinit /usr/sbin/

RUN chmod 755 /etc/service/*/run /etc/service/*/finish /usr/sbin/runit_bootstrap && \
    mkdir -p /var/log/mariadb/columnstore && \
    mkdir /docker-entrypoint-initdb.d && \
    mkdir /log 

EXPOSE 3306

VOLUME /usr/local/mariadb/columnstore/etc
VOLUME /usr/local/mariadb/columnstore/data1
VOLUME /usr/local/mariadb/columnstore/local
VOLUME /usr/local/mariadb/columnstore/mysql/db

ENTRYPOINT ["/usr/sbin/runit_bootstrap"]
