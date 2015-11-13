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
function umount_disk_and_dir()
{
	dev=$1
	dir=$2

	# umount device
	umount ${dev}1 > /dev/null 2>&1

	# delete data directory
	rm -rf ${dir}
}

#
# mount disk partition for master
#
function master_umount_disk()
{
	dev=$1
	dir=/data/master

	umount_disk_and_dir ${dev} ${dir}
}

#
# mount disk partitions for segment
#
function segment_umount_disk()
{
	local index=0
	for dev in $@
	do
		index=`expr ${index} + 1`
		dir=/data${index}/p${index}
		umount_disk_and_dir ${dev} ${dir}	
	done
}

# handle master case
if [ "$role" = "m" ]; then
	master_umount_disk $2
fi

# skip the first two arguments
shift 1

# handle segment case
if [ "$role" = "p" ]; then
	segment_umount_disk $@
fi

