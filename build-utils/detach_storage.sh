#!/bin/sh
# detach the storage from each instance
# detach_storage.sh

function detach_disk()
{
	target_host=$1
	shift 1
	target_device=$@

	ssh -o 'StrictHostKeyChecking no' root@${target_host} "~/umount_partition.sh ${target_device}" < /dev/null
}

while read line
do
	detach_disk ${line}
done

