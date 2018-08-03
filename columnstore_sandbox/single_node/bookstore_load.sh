#!/bin/bash
echo "Getting the bookstore data ..."
mkdir -p /tmp/bookstore/csv
curl https://downloads.mariadb.com/sample-data/sandbox15mr.tar.gz --output /tmp/bookstore/csv/bookstore.tar.gz
echo "Extracting bookstore files ..."
tar -vxzf /tmp/bookstore/csv/bookstore.tar.gz --directory /tmp/bookstore/csv/
sed -i 's/%CSV%/\/tmp\/bookstore\/csv\//g' /tmp/bookstore/csv/load_ax_template.sql
sed -i 's/%DB%/bookstore/g' /tmp/bookstore/csv/load_ax_template.sql

if [ $# -eq 0 ]
    then
        timeoutmin=2
    else
        timeoutmin=$1
fi
sleep=5s
iter=$(($timeoutmin*12))
echo $iter
echo "Waiting for columnstore to respond ("$timeoutmin"m)."
i=0
until (/usr/local/mariadb/columnstore/bin/mcsadmin getSystemStatus|grep -c "System        ACTIVE" > /dev/null 2>&1)
    do
        if [ "$i" -gt  "$iter" ]; then
          break
        fi
        i=$(( $i+1 ))
        sleep $sleep
        echo "Retry" $i
    done
echo "Loading Bookstore Sandbox Data ...."
/usr/local/mariadb/columnstore/mysql/bin/mysql < /tmp/bookstore/csv/load_ax_template.sql