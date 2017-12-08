FROM centos:7

# additional dependencies for docker image
RUN curl -s https://packagecloud.io/install/repositories/imeyer/runit/script.rpm.sh | bash && yum -y update && yum -y install expect perl perl-DBI openssl zlib rsyslog libaio boost file sudo libnl net-tools sysvinit-tools runit which psmisc lsof snappy wget && yum clean all

# download latest GA ColumnStore centos 7 rpms
RUN mkdir -p /install && cd /install && wget -nv -erobots=off -r -np -nH --cut-dirs 6 -A.rpm.tar.gz https://downloads.mariadb.com/ColumnStore/latest/centos/x86_64/7/ && tar xfz mariadb-columnstore-*-centos7.x86_64.rpm.tar.gz && rm -f mariadb-columnstore-*-centos7.x86_64.rpm.tar.gz 

# use this if you want to use a local copy of the centos rpm tar.gz
# ADD mariadb-columnstore-*-centos7.x86_64.rpm.tar.gz /install/
COPY install.sh /install

# install columnstore, you must copy mariadb-columnstore-<version>-centos7.x86_64.rpm.tar.gz into the directory
RUN export USER=root && yum localinstall -y /install/mariadb-columnstore*.rpm && sh /install/install.sh && rm -f /install/*.rpm /install/install.sh 

# copy runit files
COPY service /etc/service/
COPY runit_bootstrap /usr/sbin/runit_bootstrap
RUN chmod 755 /etc/service/systemd-journald/run /etc/service/rsyslogd/run /etc/service/columnstore/run /usr/sbin/runit_bootstrap

VOLUME /usr/local/mariadb/columnstore/etc
VOLUME /usr/local/mariadb/columnstore/data1
VOLUME /usr/local/mariadb/columnstore/mysql/db

EXPOSE 3306

CMD ["/usr/sbin/runit_bootstrap"]