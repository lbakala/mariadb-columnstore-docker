FROM apache/zeppelin:0.8.0

RUN apt-get update &&\
    apt-get install vim -y &&\
    apt-get install curl -y


RUN wget https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz \
    &&  tar -xzf spark-2.2.0-bin-hadoop2.7.tgz \
    &&  mv spark-2.2.0-bin-hadoop2.7 /opt/spark

ENV SPARK_HOME=/opt/spark

RUN mkdir -p  ${SPARK_HOME}/jars && \
    cd  ${SPARK_HOME}/jars && \
    curl -O https://downloads.mariadb.com/Connectors/java/connector-java-2.2.6/mariadb-java-client-2.2.6.jar


ADD spark-defaults.conf ${SPARK_HOME}/conf
ADD zeppelin-env.sh /zeppelin/conf

RUN echo "deb http://httpredir.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update 
RUN apt-get install -y libuv1 libxml2 libsnappy1v5 bzip2
RUN cd /tmp &&\
    pwd &&\
    curl -O https://downloads.mariadb.com/Data-Adapters/mariadb-columnstore-api/1.1.5/ubuntu/dists/bionic/main/binary_amd64/mariadb-columnstore-api_1.1.5-1_amd64.deb &&\ 
    pwd &&\ 
    ls -la&&\
    dpkg -i mariadb-columnstore-api*.deb
ADD Columnstore.xml /usr/local/mariadb/columnstore/etc/Columnstore.xmldocker run --rm -dit -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE='%' -e MYSQL_USER=user -e MYSQL_PASSWORD=pass