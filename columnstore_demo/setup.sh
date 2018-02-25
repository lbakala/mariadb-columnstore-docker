#!/bin/sh

# clone samples repo
yum -y install git unzip
cd /root
git clone https://github.com/mariadb-corporation/mariadb-columnstore-samples.git

# wait for columnstore to start
/usr/local/mariadb/columnstore/bin/mcsadmin startSystem

# flights
cd mariadb-columnstore-samples/flights
./get_flight_data.sh
./create_flights_db.sh
./load_flight_data.sh
 remove downloaded data to save space
rm -f data/*  

# loans 
 cd ../loans
./get_loans_data.sh
./create_loans_db.sh
./setupCrossEngine.sh
# remove downloaded data to save space
rm -f LoanStats.csv.gz

# opps
cd ../opps
./create_opps_tab.sh


# remove git to save space, leave unzip in case you want to rerun download scripts
yum -y remove git
yum clean all

# shutdown server so everything in clean state for running
/usr/local/mariadb/columnstore/bin/mcsadmin shutdownsystem y
/usr/local/mariadb/columnstore/bin/mcsadmin resetAlarm ALL
