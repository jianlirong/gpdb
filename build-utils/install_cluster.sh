#!/bin/sh
# A script to install a P1 cluster.
# install_cluster.sh

# update the /etc/hosts
cat ./hosts >> /etc/hosts

# update the hostfile and gpinitsystem_config
cat ./hostfile > /home/gpadmin/data/hostfile
cat ./gpinitsystem_config > /home/gpadmin/data/gpinitsystem_config

# setup enironment variable
source /home/gpadmin/data/greenplum_path.sh

# copy and update segment hosts
gpscp -f hostfile hosts =:~ >/dev/null 2>&1

gpssh -f hostfile -v -e 'cat ~/hosts >> /etc/hosts' > /dev/null 2>&1

# attach disk
cat disk_config | ./attach_storage.sh > /dev/null 2>&1
