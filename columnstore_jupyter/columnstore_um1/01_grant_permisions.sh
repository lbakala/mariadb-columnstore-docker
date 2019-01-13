#!/bin/bash
MCSDIR=/usr/local/mariadb/columnstore
mysql=( $MCSDIR/mysql/bin/mysql --defaults-extra-file=$MCSDIR/mysql/my.cnf -u root )
if [ ! -z "$MARIADB_ROOT_PASSWORD" ]; then
    mysql+=( -p"${MARIADB_ROOT_PASSWORD}" )
fi
#Grant all to all tables used in  the jupiter notebooks
"${mysql[@]}" -e "GRANT ALL ON test.* TO '$MARIADB_USER'@'%' ;"  2>&1
"${mysql[@]}" -e "GRANT ALL ON benchmark.* TO '$MARIADB_USER'@'%' ;"  2>&1