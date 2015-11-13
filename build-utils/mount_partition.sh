#!/bin/sh
# initialize the storage folder for GPDB
# mount_partition.sh

# check the command args
if [ $# -lt 2 ]; then
	echo -e "Opps! Needs at least 2 command line args\n"
	echo -e "Usage: $0 role dev1 dev2 ... devN\n"
	echo -e "Example: $0 m /dev/sdb"
	exit 1
fi

role=$1

# for master check
if [ "$role" = "m" ]; then
	if [ $# -ne 2 ]; then
		echo -e "For master, only accept 2 command line args\n"
		exit 1
	fi
fi

#
# mount a disk to a data directory
#
function mount_disk_to_dir()
{
	dev=$1
	dir=$2
	# add disk partition
	(echo n; echo p; echo 1; echo; echo; echo w) | fdisk ${dev} > /dev/null 2>&1

	# format the newly created partition
	mkfs -t ext4 ${dev}1 > /dev/null 2>&1

	# create data directory
	mkdir -p ${dir}

	# mount disk partition to the data directory
	mount -o rw ${dev}1 ${dir}

	# change the owner and group of the data directory
	chown -R gpadmin ${dir}
	chgrp -R gpadmin ${dir}
}

#
# mount disk partition for master
#
function master_mount_disk()
{
	dev=$1
	dir=/data/master

	mount_disk_to_dir ${dev} ${dir}
}

#
# mount disk partitions for segment
#
function segment_mount_disk()
{
	local index=0
	for dev in $@
	do
		index=`expr ${index} + 1`
		dir=/data${index}/p${index}
		mount_disk_to_dir ${dev} ${dir}	
	done
}

# handle master case
if [ "$role" = "m" ]; then
	master_mount_disk $2
fi

# skip the first two arguments
shift 1

# handle segment case
if [ "$role" = "p" ]; then
	segment_mount_disk $@
fi

