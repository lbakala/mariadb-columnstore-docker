# ColumnStore Spark Example

## Introduction
This folder contains a docker-compose.yml file which runs spark with a jupyter notebook and the MariaDB ColumnStore Spark connector integrated with a single node MariaDB ColumnStore server.

## To Run
Simply type:
```sh
docker-compose up -d
```

After this has launched the 2 containers navigate to http://localhost:8888 in your browser and enter 'mariadb' as the password.

For further details see https://mariadb.com/kb/en/library/mariadb-columnstore-with-spark/ 

