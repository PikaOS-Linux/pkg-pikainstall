#! /bin/bash

if [[ -z $2 ]]
then
	echo "no mount point specified" && exit 1
fi

if [[ "$1" == "part" ]]
then
	df -P -h -T "$2" | awk 'END{print $1}'
elif [[ "$1" == "block" ]]
then
	echo "/dev/$(lsblk -ndo pkname $(df -P "$2" | awk 'END{print $1}'))"
elif [[ "$1" == "uuid" ]]
then
	blkid "$(df -P -h -T "$2" | awk 'END{print $1}')" -s UUID -o value
else
	echo "invalid first args not in: part, block, uuid" && exit 1
fi

