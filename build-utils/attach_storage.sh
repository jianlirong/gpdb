#!/bin/sh
# attach the storage to each instance
# attach_storage.sh

function attach_disk()
{
	target_host=$1
	shift 1
	target_device=$@

	ssh -o 'StrictHostKeyChecking no' root@${target_host} "~/mount_partition.sh ${target_device}" < /dev/null
}

while read line
do
	attach_disk ${line}
done

