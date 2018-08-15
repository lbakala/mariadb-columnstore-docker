FROM apache/zeppelin:0.8.0
RUN apt-get update && \
    apt-get install vim -y \
    && apt-get install curl -y \
    && wget https://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz \
    && tar -xzf spark-2.2.0-bin-hadoop2.7.tgz \
    && mv spark-2.2.0-bin-hadoop2.7 /opt/spark \
    && apt-get install -y libuv1 libxml2 libsnappy1v5 bzip2 \
    && cd /tmp \
    && curl -O https://downloads.mariadb.com/Data-Adapters/mariadb-columnstore-api/1.1.5/ubuntu/dists/bionic/main/binary_amd64/mariadb-columnstore-api_1.1.5-1_amd64.deb \
    && dpkg -i mariadb-columnstore-api*.deb

ENV SPARK_HOME=/opt/spark

RUN mkdir -p  ${SPARK_HOME}/jars && \
    cd  ${SPARK_HOME}/jars && \
    curl -O https://downloads.mariadb.com/Connectors/java/connector-java-2.2.6/mariadb-java-client-2.2.6.jar
ADD spark-defaults.conf ${SPARK_HOME}/conf
ADD zeppelin-env.sh /zeppelin/conf
#Overwritten in multinode.
ADD Columnstore.xml /usr/local/mariadb/columnstore/etc/Columnstore.xml
COPY notebook /zeppelin/notebook