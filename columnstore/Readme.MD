# MariaDB ColumnStore Docker Container Setup

## Introduction
This docker image will startup a single server instance of MariaDB ColumnStore running on CENTOS 7. It is designed and suitable for demo and evaluation.

## Requirements
The following are required:
- A computer with a 64bit OS, CPU virtualization extensions enabled in the BIOS and minimum 6GB RAM
- Docker
- This git tree


## Running and managing the ColumnStore Container
- The latest version of the container is available for download from [docker hub](https://hub.docker.com/r/mariadb/columnstore/) or alternatively it can be built locally (for directions see later section on building).
- Use docker run to start the container (the --name argument allows specification of a specific container name):

```sh
$ docker run -d --name mcs mariadb/columnstore
```
- By default the container will configure and start a single server node. To track progress and determine when the columnstore instance is up and active use:

```sh
$ docker logs -f mcs
```

- The following output will be seen indicating the server is up:

```sh
Starting MariaDB Columnstore Database Platform

MariaDB ColumnStore Database Platform Starting, please wait ....... DONE

System Catalog Successfull Created

MariaDB ColumnStore Install Successfully Completed, System is Active

Enter the following command to define MariaDB ColumnStore Alias Commands

. /usr/local/mariadb/columnstore/bin/columnstoreAlias

Enter 'mcsmysql' to access the MariaDB ColumnStore SQL console
Enter 'mcsadmin' to access the MariaDB ColumnStore Admin console

NOTE: The MariaDB ColumnStore Alias Commands are in /etc/profile.d/columnstoreAlias.sh

Container initialization complete at Tue Jul 24 05:16:48 UTC 2018
```

- To access tools such as mcsadmin and cpimport for data loading, it is easiest to run docker exec for shell access into the container:

```sh
$ docker exec -it mcs bash
$ mcsadmin getsystemstatus
$ mcsmysql
$...
```
- To stop the container:

```sh
$ docker stop mcs
```
- To start the container after stopping:

```sh
$ docker start mcs
```

- To block until the columnstore cluster is fully up a helper script can be used (the -d arg can be omitted if you do not wish to see status check output):

```sh
$ /sbin/wait_for_columnstore_active -d
```

- To remove the container (-v removes the associated data volumes for the database storage):

```sh
$ docker rm -v mcs
```

- To remove the image

```sh
$ docker rmi mariadb/columnstore
```
## Customization
The container can be customized by environment variables and a custom directory with initialization scripts.

### PostConfigure Input
The environment variable CS_POSTCFG_INPUT can be overridden to specify different input values to postConfigure. The default value in the Dockerfile will start up a single server deployment. If the environment variable is empty then postConfigure will not be run and the container will just run the ColumnStore service process ProcMon.

### Database creation
The environment variable CS_DATABASE can be set in which case a database with that name will be created after the cluster is active.

### Custom scripts
Scripts in a host volume directory mounted as /docker-entrypoint-initdb.d will be run on the container after postConfigure is complete (or after the cluster is active). Support is provided for .sql, .sql.gz, and .sh scripts.

## Multi Node Cluster compose file
- The docker-compose.yml file will bring up a 2um 2pm cluster using local storage
per container to allow easy evaluation of a multi node cluster. To run this:

```sh
$ docker-compose up -d
```

- To verify the cluster is up and active follow logs on the pm1 node and look for
similar output to the single node deployment:

```sh
$ docker-compose logs -f pm1
```

- To stop the containers and remove volumes:

```sh
$ docker-compose down -v
```


## Building
- Install docker: https://docs.docker.com/engine/installation/
- Run docker build to create the docker image, feel free to choose your own container name other than mariadb/columnstore:

```sh
$ cd mariadb-columnstore-docker/columnstore
$ docker build -t mariadb/columnstore .
```
