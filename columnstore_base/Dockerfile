FROM centos:7

COPY mariadb-columnstore.repo runit.repo /etc/yum.repos.d/
COPY postCfg.sh /install/
COPY service /etc/service/
COPY runit_bootstrap /usr/sbin/
COPY dbinit /usr/sbin/

# additional dependencies for docker image
RUN yum -y update && \
    export USER=root && \
    groupadd -r mysql && \
    useradd -r -g mysql mysql && \
    yum -y install expect perl perl-DBI openssl zlib rsyslog libaio boost file sudo libnl net-tools sysvinit-tools runit which psmisc lsof snappy rsync wget && \
    yum -y install mariadb-columnstore-client mariadb-columnstore-common mariadb-columnstore-libs mariadb-columnstore-platform mariadb-columnstore-server mariadb-columnstore-shared mariadb-columnstore-storage-engine && \
    yum clean all && \
    mkdir /docker-entrypoint-initdb.d && \
    mkdir /log && \
    chmod 755 /etc/service/*/run /etc/service/*/finish /usr/sbin/runit_bootstrap /install/postCfg.sh && \
    mkdir -p /var/log/mariadb/columnstore && \
    /usr/bin/systemd-machine-id-setup && \
    /bin/echo "export USER=root" >> /root/.bashrc

EXPOSE 3306

CMD ["/usr/sbin/runit_bootstrap"]
