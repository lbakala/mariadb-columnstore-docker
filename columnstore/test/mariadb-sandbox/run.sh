#!/bin/bash
. ./test/helpers/testfwk.sh
CS_INIT_FLAG=/usr/local/mariadb/columnstore/etc/container-initialized
TEST_MARIADB_CONTAINER_NAME=$1 #This is a multinode test which creates its own containers. This variable is not used. 
shift 1
export MARIADB_host='127.0.0.1'
export MARIADB_ROOT_PASSWORD='this is an example test password'
export MARIADB_USER='zeppelin_user'
export MARIADB_PASSWORD='zeppelin_pass'
export MARIADB_DATABASE='bookstore'
export MARIADB_CS_TAG=mariadb/columnstore
export MARIADB_CS_VERSION=1.2
export COMPOSE_PROJECT_NAME='sandboxtest'
set -e
cd ../columnstore
if [[ -z $MARIADB_TEST_DEBUG ]]; then
    docker build -t ${MARIADB_CONTAINER_NAME} --quiet . &> /dev/null 
else
    docker build -t ${MARIADB_CONTAINER_NAME} .
fi
cd ../columnstore_zeppelin
if [[ -z $MARIADB_TEST_DEBUG ]]; then
    docker-compose down -v &> /dev/null 
    echo 'y' | docker volume prune &> /dev/null 
    echo 'y' | docker network prune &> /dev/null 
else
    docker-compose down -v
    echo 'y' | docker volume prune 
    echo 'y' | docker network prune
fi
echo ''

if [[ -z $MARIADB_TEST_DEBUG ]]; then
    docker-compose up --build -d &> /dev/null 
else
    docker-compose up --build -d
fi
cd ../columnstore

cname_z="${COMPOSE_PROJECT_NAME}_zeppelin_1"
cname_um="${COMPOSE_PROJECT_NAME}_um1_1"

ATTEMPT=1
while [ -z "$(docker ps -a | grep $cname_um)" ] && [ $ATTEMPT -le 60 ]; do
    echo -ne ","
    sleep 1
    ATTEMPT=$(($ATTEMPT+1))
done

docker cp ./test/mariadb-sandbox/initdb.sql $cname_um:/docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um sed -i s/\#\#test_db_name\#\#/"$MARIADB_DATABASE"/g /docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um sed -i s/\#\#test_user_name\#\#/"$MARIADB_USER"/g /docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um sed -i s/\#\#test_user_pass\#\#/"$MARIADB_PASSWORD"/g /docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um sed -i s/\#\#test_bookstore_db\#\#/"$MARIADB_DATABASE"/g /docker-entrypoint-initdb.d/test_initdb.sql
set +e 

mysql() {
    res=$(docker exec $cname_um mysql \
        --host="$MARIADB_HOST" \
        --user=''"${MARIADB_USER}"'' \
        --password=''"${MARIADB_PASSWORD}"'' \
        --silent \
        --skip-column-names \
        --protocol=TCP \
        "$1" \
        -e "$2")
    if [ $? -eq 0 ]; then
        echo $res
    else
        echo $FAIL_STRING
    fi
}

#Check if CS is initialised
ATTEMPT=1

while ! $(docker exec $cname_um test -f "$CS_INIT_FLAG") && [ $ATTEMPT -le 60 ]; do
    echo -ne "."
    sleep 5
    ATTEMPT=$(($ATTEMPT+1))
done
echo $ATTEMPT

docker exec $cname_um rm -rf /docker-entrypoint-initdb.d/test_initdb.sql

tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT CURRENT_USER();')" = "$MARIADB_USER@localhost" ]" "Testing SELECT CURRENT_USER();. Expected: $MARIADB_USER@localhost" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT 1')" = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT 1')" = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT 1')" = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT 1')" = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM test')" = 1 ]" "Testing SELECT COUNT(*) FROM test. Expected: 1" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT c FROM test')" == 'goodbye!' ]" "Testing SELECT c FROM test. Expected: goodbye!" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT price from transactions WHERE transaction_type = 1 ORDER BY price LIMIT 1')" == "1.49" ]" "Testing SELECT price from transactions WHERE transaction_type = 1 ORDER BY price LIMIT 1;. Expected: 1.49" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM addresses')" = 2666749 ]" "Testing SELECT COUNT(*) FROM addresses. Expected: 2666749" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM books')" = 5001 ]" "Testing SELECT COUNT(*) FROM books. Expected: 5001" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM cards')" = 1604661 ]" "Testing SELECT COUNT(*) FROM cards. Expected: 1604661" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM covers')" = 20 ]" "Testing SELECT COUNT(*) FROM covers. Expected: 20" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM customers')" = 2005397 ]" "Testing SELECT COUNT(*) FROM customers. Expected: 2005397" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM emails')" = 2566571 ]" "Testing SELECT COUNT(*) FROM emails. Expected: 2566571" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM loyaltypoints')" = 923008 ]" "Testing SELECT COUNT(*) FROM loyaltypoints. Expected: 923008" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM maritalstatuses')" = 5 ]" "Testing SELECT COUNT(*) FROM maritalstatuses. Expected: 5" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM phones')" = 2427033 ]" "Testing SELECT COUNT(*) FROM phones. Expected: 2427033" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM transactions')" = 11279171 ]" "Testing SELECT COUNT(*) FROM transactions. Expected: 11279171" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT COUNT(*) FROM transactiontypes')" = 3 ]" "Testing SELECT COUNT(*) FROM transactiontypes. Expected: 3" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT price from transactions WHERE transaction_type = 1 ORDER BY price LIMIT 1')" == "1.49" ]" "Testing SELECT price from transactions WHERE transaction_type = 1 ORDER BY price LIMIT 1;. Expected: 1.49" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT sum(price) FROM transactions')" == "115003016.41" ]" "Testing SELECT sum(price) FROM transactions. Expected: 115003016.41" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SELECT DISTINCT count(customer_id) from transactions')" == "11279171" ]" "Testing SELECT DISTINCT count(customer_id) from transactions. Expected: 11279171" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SET @@max_length_for_sort_data = 501;SELECT p.p FROM (SELECT bookname,category, sum(cover_price) p from books group by bookname,category) p ORDER BY category LIMIT 1')" == $FAIL_STRING ]" "Testing limited sort. Expected: FAIL" )
tests+=( "[ "$(mysql "$MARIADB_DATABASE" 'SET @@max_length_for_sort_data = 5001;SELECT p.p FROM (SELECT bookname,category, sum(cover_price) p from books group by bookname,category) p ORDER BY bookname,category LIMIT 1')" == "11.89" ]" "Testing within the limit. Expected: 11.89" )
tests+=( "[ "$(docker exec -i $cname_um wc -l /var/log/mariadb/columnstore/info.log | cut -d ' ' -f 1)" -gt 0 ]" "Testing log at /var/log/mariadb/columnstore/info.log. Expected: some rows" )
start_tst tests[@] 3

cd ../columnstore_zeppelin
if [[ -z $MARIADB_TEST_DEBUG ]]; then
    docker-compose down -v 2>/dev/null
else
    docker-compose down -v
fi
cd ../columnstore