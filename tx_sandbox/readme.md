# MariaDB TS Sandbox Docker ImageDataset

This sandbox data loaded in this doker image is based on procedural generated data representing a typical online bookstore data.
The names of the books, authors and customers are all procedural generated.  
*Any matches with actual books titles and names are coinsidental.*

The data is generated to illustrate the capabilities of  **MariaDB AX**  and **MariaDB TX** products of MariaDB Corporation.


# Startup parameters 

## Build and run using docker-compose
      '''bash
      docre-compose up --build
      '''
Navigate to [[http://localhost:8080/?server=server&username=sandbox&db=bookstore]]

Default password is:
```highlyillogical```

## Build and run using docker

### Build

```
docker build --build-arg root_pass=secret_pass -t mariadb:tx_sandbox .
`root_pass` holds the the password to be set for the MySQL root user and
```

### Run

```
$ docker run --name tx_sandbox -d mariadb:tx_sandbox
```

... where tx_sandbox is the name you want to assign to your runnig container, tag is the tag specifying the MySQL version you want. See the list above for relevant tags.