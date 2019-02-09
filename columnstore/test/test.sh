#!/bin/bash
export MARIADB_TEST_DEBUG=
export MARIADB_CS_DEBUG=

if [[ "${PWD##*/}" == "test" ]];then
    cd ..
fi
. ./test/helpers/testfwk.sh

cleanup(){
    # cleanup
    docker stop $(docker ps -aq --filter name=''${MARIADB_TEST_CONTAINER_PREFIX}'')  &> /dev/null 
    docker rm $(docker ps -aq --filter name=''${MARIADB_TEST_CONTAINER_PREFIX}'')  &> /dev/null 
    echo 'y' | docker network prune &> /dev/null 
    echo ''
}

UUID=$(dbus-uuidgen)
export MARIADB_TEST_CONTAINER_PREFIX="mtest${UUID: -8}"  #underscores in the docker project name are not accepted well by the travis docker service. 
                                                         #we also have to keep the complete DNS container host name below 60 characters as enforced by mysql.user

if [[ ! -z "$1" ]]; then
    export MARIADB_CONTAINER_NAME="${1}"
else 
    export MARIADB_CONTAINER_NAME="mariadb/columnstore:latest"
fi

echo 'y' | docker volume prune &> /dev/null 
echo ''
echo 'y' | docker network prune &> /dev/null 
echo ''
echo "Test started"
trap cleanup EXIT
echo "Building ${MARIADB_CONTAINER_NAME}"
docker build -t ${MARIADB_CONTAINER_NAME} . --quiet


#########################################
#                                       #
#         Test scope definitions        #
#                                       #
#########################################
tests+=( "./test/mariadb-docker/run.sh" "Test mariadb-docker" )
tests+=( "./test/mariadb-multinode/run.sh" "Test mariadb-multinode" )
tests+=( "./test/mariadb-sandbox/run.sh" "Test mariadb-sandbox" )
if [ ${#tests[@]} -gt 0 ]; then
    echo ""
    echo "Running test suite for ${MARIADB_CONTAINER_NAME}"
    echo "----------------------------------------------------------------" 
    start_tst tests[@]
fi
