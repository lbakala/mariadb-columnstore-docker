FROM jupyter/all-spark-notebook:c7fb6660d096

USER root
RUN  mkdir -p /usr/share/java && cd /usr/share/java && curl -O https://downloads.mariadb.com/Connectors/java/connector-java-2.2.0/mariadb-java-client-2.2.0.jar && cd /usr/lib && curl -O http://search.maven.org/remotecontent?filepath=junit/junit/4.12/junit-4.12.jar

ADD spark-defaults.conf /usr/local/spark/conf
ADD Python_Example.ipynb /home/jovyan
ADD Scala_Example.ipynb /home/jovyan
ADD Python_mcsapi_connector_Example.ipynb /home/jovyan
ADD Scala_mcsapi_connector_Example.ipynb /home/jovyan
ADD Python_mcsapi_connector_Test.ipynb /home/jovyan
ADD Scala_mcsapi_connector_Test.ipynb /home/jovyan
ADD Python_JDBC_API_Benchmark.ipynb /home/jovyan
ADD Scala_JDBC_API_Benchmark.ipynb /home/jovyan

RUN apt-get update && apt-get install -y libuv1 libxml2 libsnappy1v5 && cd /tmp && curl -O https://downloads.mariadb.com/Data-Adapters/mariadb-columnstore-api/latest/ubuntu/dists/xenial/main/binary_amd64/mariadb-columnstore-api-1.1.3-1-x86_64-xenial.deb && dpkg -i mariadb-columnstore-api-*.deb && rm mariadb-columnstore-api-*.deb && ln -s /usr/lib/python3/dist-packages/columnStoreExporter.py /opt/conda/lib/python3.6/site-packages/ && ln -s /usr/lib/python3/dist-packages/pymcsapi.py /opt/conda/lib/python3.6/site-packages/ && ln -s /usr/lib/python3/dist-packages/_pymcsapi.so /opt/conda/lib/python3.6/site-packages/ && mkdir -p /usr/local/mariadb/columnstore/etc && conda install -y -c anaconda pytest mysql-connector-python

ADD Columnstore.xml /usr/local/mariadb/columnstore/etc/Columnstore.xml
