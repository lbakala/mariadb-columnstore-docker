#!/bin/bash
if [[ "${PWD##*/}" == "test" ]];then
    cd ..
fi
. ./test/helpers/testfwk.sh
export MARIADB_TEST_DEBUG=
export MARIADB_CS_DEBUG=
if [[ ! -z "$1" ]]; then
    export MARIADB_CONTAINER_NAME="${1}"
else 
    export MARIADB_CONTAINER_NAME="mariadb/columnstore:latest"
fi
echo "Building ${MARIADB_CONTAINER_NAME}"
docker build -t ''${MARIADB_CONTAINER_NAME}'' . --quiet
#tests+=( "./test/mariadb-docker/run.sh $MARIADB_CONTAINER_NAME" "Test mariadb-docker" )
tests+=( "./test/mariadb-sandbox/run.sh $MARIADB_CONTAINER_NAME" "Test mariadb-sandbox" )
if [ ${#tests[@]} -gt 0 ]; then
    echo ""
    echo "Running test suite for ${MARIADB_CONTAINER_NAME}"
    echo "----------------------------------------------------------------" 
    start_tst tests[@]
fi