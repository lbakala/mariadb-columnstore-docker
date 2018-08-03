# MariaDB AX Columnstore Sandbox with Zeppelin Notebooks
 
## Building
- Install docker: https://docs.docker.com/engine/installation/
- Run docker build to create the docker image, feel free to choose your own container name other than mariadb/columnstore:

Build columnstore
```sh
$ docker build -t mariadb/columnstore:latest ../columnstore
```

Build columnstore with the sandbox dataset
```sh
$ docker build -t mariadb/columnstore_sandbox:latest ../columnstore_sandbox
```

Build zeppelin instance.
```sh
$ docker build -t mariadb/columnstore_zeppelin:latest ../columnstore_zeppelin
```

Bring the whole cluster
```sh
$ docker-compose up -d
```