
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

Build columnstore
```sh
$ docker build -t mariadb/columnstore:1.2 ../columnstore
```

Build columnstore with the sandbox dataset
```sh
$ docker build -t mariadb/columnstore_sandbox:1.2.2 ../columnstore_sandbox
```