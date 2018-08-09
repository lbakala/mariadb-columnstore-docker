# MariaDB AX Columnstore Sandbox with Zeppelin Notebooks
 
## Building
- Install docker: https://docs.docker.com/engine/installation/

The space requirement for the docker images is around 4GB

Make sure you are in columnstore_zeppelin folder
```sh
$ cd columnstore_zeppelin
```

### Build columnstore
```sh
$ docker build -t mariadb/columnstore:latest ../columnstore
```

### Build Zeppelin instance.
```sh
$ docker build -t mariadb/columnstore_zeppelin:latest ../columnstore_zeppelin
```

### Bring the whole cluster up

The command to bring the whole cluster us is:
```sh
$ docker-compose up --build
```

It can take up to 10 min before the cluster starts and the data is ingested. 

The status of data ingest can be tracked in the UM1 container log file.

```sh
$ docker logs -f columnstore_zeppelin_um1_1
```

Open Zeppelin from this link
[http://localhost:8080](http://localhost:8080)

Database can be accessed directly with: 
```sql
$ mysql -h127.0.0.1 -uzeppelin_user -pzeppelin_pass bookstore
```

### Troubleshooting
In case you run a service on 3306,3307 or 8080 the ports configuration in docker-compose.yml should be changed.
You might encounter the following error
```
ERROR: Encountered errors while bringing up the project.
```

i.e. if we have another MariaDB server running on port 3306 
The following configuration

```
    ports:
      - "3306:3306"
```

Should be altered like this:

```
    ports:
      - "3308:3306"
```
Assuming 3308 is ubnbound on our machine.