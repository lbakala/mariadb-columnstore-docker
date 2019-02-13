cd ./columnstore_zeppelin
docker build -t mariadb/columnstore:1.2 ../columnstore
echo 'y' | docker network prune &> /dev/null 
echo ''
docker-compose up --build
docker-compose down -v