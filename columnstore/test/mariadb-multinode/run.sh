#!/bin/bash
. ./test/helpers/testfwk.sh
CS_INIT_FLAG=/usr/local/mariadb/columnstore/etc/container-initialized

export MARIADB_HOST='127.0.0.1'
export MARIADB_UM1_BINDING=3306 #Unbind service
export MARIADB_ROOT_PASSWORD='this is an example test password'
export MARIADB_USER='0123456789012345' # "ERROR: 1470  String 'my cool mysql user' is too long for user name (should be no longer than 16)"
export MARIADB_PASSWORD='my cool mariadb password'
export MARIADB_DATABASE='my cool mariadb database'
secp=$(date +%s)
minp=$(date +%M)
export MARIADB_CS_NETWORK_SPACE="10.$((10#${minp} +11)).$((10#${secp: -2} + 11))"
export COMPOSE_PROJECT_NAME=''${MARIADB_TEST_CONTAINER_PREFIX}multinode''
TEST_WAIT_ATTEMPTS=120
echo -ne "Network:${MARIADB_CS_NETWORK_SPACE}.0/24"

cleanup(){
    if [[ -z ${MARIADB_TEST_DEBUG} ]]; then
        docker-compose down -v 2>/dev/null
    else
        docker-compose down -v
    fi
}

set -e
cd ../columnstore
if [[ -z ${MARIADB_TEST_DEBUG} ]]; then
    docker build -t ${MARIADB_CONTAINER_NAME} --quiet . &> /dev/null 
else
    docker build -t ${MARIADB_CONTAINER_NAME} .
fi
if [[ -z ${MARIADB_TEST_DEBUG} ]]; then
    docker-compose down -v &> /dev/null 
else
    docker-compose down -v
fi

if [[ -z ${MARIADB_TEST_DEBUG} ]]; then
    docker-compose up --build -d &> /dev/null 
else
    docker-compose up --build -d
fi
trap cleanup EXIT
cname_um1="${COMPOSE_PROJECT_NAME}_um1_1"
cname_pm1="${COMPOSE_PROJECT_NAME}_pm1_1"
cname_pm2="${COMPOSE_PROJECT_NAME}_pm2_1"

ATTEMPT=1
while [ -z "$(docker ps -a | grep $cname_um1)" ] && [ $ATTEMPT -le 20 ]; do
    echo -ne ","
    sleep 1
    ATTEMPT=$(($ATTEMPT+1))
done

docker cp ./test/mariadb-multinode/initdb.sql $cname_um1:/docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um1 sed -i s/\#\#test_db_name\#\#/"$MARIADB_DATABASE"/g /docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um1 sed -i s/\#\#test_user_name\#\#/"$MARIADB_USER"/g /docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um1 sed -i s/\#\#test_user_pass\#\#/"$MARIADB_PASSWORD"/g /docker-entrypoint-initdb.d/test_initdb.sql
docker exec $cname_um1 sed -i s/\#\#test_bookstore_db\#\#/"$MARIADB_DATABASE"/g /docker-entrypoint-initdb.d/test_initdb.sql
set +e 

mysql() {
    res=$(docker exec $cname_um1 mysql \
        --host="$MARIADB_HOST" \
        --user=''"${MARIADB_USER}"'' \
        --password=''"${MARIADB_PASSWORD}"'' \
        --silent \
        --skip-column-names \
        --protocol=TCP \
        ''"$1"'' \
        -e "$2")
    if [ $? -eq 0 ]; then
        echo $res
    else
        echo $FAIL_STRING
    fi
}

#Check if CS is initialised
ATTEMPT=1

while (! $(docker exec $cname_um1 test -f "$CS_INIT_FLAG") || ! $(docker exec $cname_pm1 test -f "$CS_INIT_FLAG") || ! $(docker exec $cname_pm2 test -f "$CS_INIT_FLAG")) && [ $ATTEMPT -le $TEST_WAIT_ATTEMPTS ]; do
    echo -ne "."
    sleep 5
    ATTEMPT=$(($ATTEMPT+1))
done
echo $ATTEMPT


if [[ ! -z $MARIADB_TEST_DEBUG ]] || [ $ATTEMPT -gt $TEST_WAIT_ATTEMPTS ]; then
    echo "$(( (${ATTEMPT}-1)*5 )) seconds."
    echo ""
    echo ">>>>>>>>>>>>> docker-compose logs follow. <<<<<<<<<<<<<"
    docker-compose logs -t
    echo ">>>>>>>>>>>>> docker-compose logs end. <<<<<<<<<<<<<"
fi

docker exec $cname_um1 rm -rf /docker-entrypoint-initdb.d/test_initdb.sql

tests+=( "[ $ATTEMPT -le $TEST_WAIT_ATTEMPTS ]" "Testing if Columnstore was initialized successfully. Expected: True" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT CURRENT_USER();') = \"$MARIADB_USER@localhost\" ]" "Testing SELECT CURRENT_USER();. Expected: $MARIADB_USER@localhost" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT 1') = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT 1') = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT 1') = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT COUNT(*) FROM test') = 1 ]" "Testing SELECT COUNT(*) FROM test. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT c FROM test') == 'goodbye!' ]" "Testing SELECT c FROM test. Expected: goodbye!" )
tests+=( "[ \$(docker exec -i $cname_um1 wc -l /var/log/mariadb/columnstore/info.log | cut -d ' ' -f 1) -gt 0 ]" "Testing log at /var/log/mariadb/columnstore/info.log. Expected: some rows" )
start_tst tests[@] 3
