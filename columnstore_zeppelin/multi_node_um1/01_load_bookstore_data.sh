#!\bin/sh
echo "Getting the bookstore data ..."
mkdir -p /tmp/bookstore-csv
if [ ! -f "/docker-entrypoint-initdb.d/sandbox15mr.tar" ]; then
  curl https://downloads.mariadb.com/sample-data/sandbox15mr.tar --output /docker-entrypoint-initdb.d/sandbox15mr.tar
fi

echo "Extracting bookstore files ..."
tar -xf /docker-entrypoint-initdb.d/sandbox15mr.tar --directory /tmp/bookstore-csv

echo "loading bookstore files ..."
# gunzip cover.csv.gz as will use LDI for innodb table later and simplifies
# for loop below.
currentDir=$(pwd)
cd /tmp/bookstore-csv
gunzip covers.csv.gz
for i in *.csv.gz; do
    table=$(echo $i | cut -f 1 -d '.')
    zcat  $table.csv.gz | /usr/local/mariadb/columnstore/bin/cpimport -s ',' -E "'" bookstore $table
    rm -f $table.csv.gz
done

# now load the covers table which is innodb so use load data local infile
/usr/local/mariadb/columnstore/mysql/bin/mysql -u root bookstore -e "load data local infile 'covers.csv' into table covers fields terminated by ',' enclosed by '''';"
cd $currentDir
rm -rf /tmp/bookstore-csv
