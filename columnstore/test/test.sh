#!/bin/bash
if [[ "${PWD##*/}" == "test" ]];then
    cd ..
fi
. ./test/helpers/testfwk.sh
export MARIADB_TEST_DEBUG=0
CONTAINER_NAME="$1"
CONTAINER_NAME=${CONTAINER_NAME:-"default-container-name"}
echo "Building $CONTAINER_NAME"
docker build -t $CONTAINER_NAME . --quiet
tests+=( "./test/mariadb-docker/run.sh $CONTAINER_NAME" "Test mariadb-docker" )
#tests+=( "./test/mariadb-sandbox/run.sh $CONTAINER_NAME" "Test mariadb-sandbox" )
if [ ${#tests[@]} -gt 0 ]; then
    echo ""
    echo "Running test suite for ${CONTAINER_NAME}"
    echo "----------------------------------------------------------------" 
    start_tst tests[@]
fi