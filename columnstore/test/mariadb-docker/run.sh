#!/bin/bash
. ./test/helpers/testfwk.sh
CS_INIT_FLAG=/usr/local/mariadb/columnstore/etc/container-initialized
TEST_CONTAINER_NAME=$1
TEST_WAIT_ATTEMPTS=60
shift 1
export MARIADB_HOST='127.0.0.1'
export MARIADB_ROOT_PASSWORD='this is an example test password'
export MARIADB_USER='0123456789012345' # "ERROR: 1470  String 'my cool mysql user' is too long for user name (should be no longer than 16)"
export MARIADB_PASSWORD='my cool mariadb password'
export MARIADB_DATABASE='my cool mariadb database'
cname="${MARIADB_TEST_CONTAINER_PREFIX}docker"
cid="$(
    docker create \
        -e MARIADB_ROOT_PASSWORD \
        -e MARIADB_USER \
        -e MARIADB_PASSWORD \
        -e MARIADB_DATABASE \
        --name "$cname" \
        $MARIADB_CONTAINER_NAME
)"
docker cp ./test/mariadb-docker/initdb.sql $cid:/docker-entrypoint-initdb.d/initdb.sql
cid="$(docker start $cid)"
docker exec $cid sed -i s/\#\#test_db_name\#\#/"$MARIADB_DATABASE"/g /docker-entrypoint-initdb.d/initdb.sql
trap "docker rm -vf $cid > /dev/null" EXIT

mysql() {
    res=$(docker exec $cname mysql \
        -h $MARIADB_HOST \
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
while ! $(docker exec $cid test -f "$CS_INIT_FLAG") && [ $ATTEMPT -le $TEST_WAIT_ATTEMPTS ]; do
    echo -ne "."
    sleep 5
    ATTEMPT=$((ATTEMPT+1))
done
echo $ATTEMPT

if [[ ! -z $MARIADB_TEST_DEBUG ]] || [ $ATTEMPT -gt $TEST_WAIT_ATTEMPTS ]; then
    echo "$(( (${ATTEMPT}-1)*5 )) seconds."
    echo ""
    echo ">>>>>>>>>>>>> docker logs for $cid follow. <<<<<<<<<<<<<"
    docker logs -t $cid
    echo ">>>>>>>>>>>>> docker logs for $cid end. <<<<<<<<<<<<<"
fi

tests+=( "[ $ATTEMPT -le $TEST_WAIT_ATTEMPTS ]" "Testing if Columnstore was initialized successfully. Expected: True" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT CURRENT_USER();') = \"$MARIADB_USER@localhost\" ]" "Testing SELECT CURRENT_USER();. Expected: $MARIADB_USER@localhost" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT 1') = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT 1') = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT 1') = 1 ]" "Testing SELECT 1. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT COUNT(*) FROM test') = 1 ]" "Testing SELECT COUNT(*) FROM test. Expected: 1" )
tests+=( "[ \$(mysql \"$MARIADB_DATABASE\" 'SELECT c FROM test') == 'goodbye!' ]" "Testing SELECT c FROM test. Expected: goodbye!" )
tests+=( "[ \$(docker exec $cid wc -l /var/log/mariadb/columnstore/info.log | cut -d ' ' -f 1) -gt 0 ]" "Testing log at /var/log/mariadb/columnstore/info.log. Expected: some rows" )
start_tst tests[@] 3
