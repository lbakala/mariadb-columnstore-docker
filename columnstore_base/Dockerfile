FROM centos:7

# additional dependencies for docker image
RUN curl -s https://packagecloud.io/install/repositories/imeyer/runit/script.rpm.sh | bash && \
   yum -y update && \
   yum -y install expect perl perl-DBI openssl zlib rsyslog libaio boost file sudo libnl net-tools sysvinit-tools runit which psmisc lsof snappy rsync wget && \ 
   yum clean all

COPY postCfg.sh /install/
COPY service /etc/service/
COPY runit_bootstrap /usr/sbin/

RUN mkdir -p /install/tmp && \
	cd /install/tmp && \
	wget -nv -erobots=off -r -np -nH --cut-dirs 6 -A.rpm.tar.gz https://downloads.mariadb.com/ColumnStore/latest/centos/x86_64/7/ && \
	tar xfz mariadb-columnstore-*-centos7.x86_64.rpm.tar.gz && \
	export USER=root && \
	yum localinstall -y mariadb-columnstore*.rpm && \
	cd /install && \
	chmod 755 /etc/service/*/run /etc/service/*/finish /usr/sbin/runit_bootstrap && \
    mkdir -p /var/log/mariadb/columnstore && \
    /usr/bin/systemd-machine-id-setup && \
	/bin/echo "export USER=root" >> /root/.bashrc && \
    rm -rf /install/tmp

EXPOSE 3306

CMD ["/usr/sbin/runit_bootstrap"]
