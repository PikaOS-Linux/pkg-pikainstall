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
elif [[ $1 == "flag" ]]
then
	if [[ -z $3 ]]
	then
		echo "no flag specified" && exit 1
	elif [[ -z $4 ]]
	then
		echo "no flag state specified" && exit 1
	else
		PART_BLOCK=/dev/$(lsblk -ndo pkname $(df -P "$2" | awk 'END{print $1}'))
		PART_DEVICE=$(df -P -h -T "$2" | awk 'END{print $1}')
		PART_DEVICE_NUM=$(echo $PART_DEVICE | sed "s#$PART_BLOCK##" | tr -dc '0-9')
		echo "setting flag $3 to $4 on $2 ($PART_DEVICE)"
		parted $PART_BLOCK set $PART_DEVICE_NUM $3 $4
	fi
elif [[ $1 == "encrypt-part" ]]
then
	if blkid -o value -s TYPE $(lsblk -sJp | jq -r --arg dsk "$(df -P -h -T "$2" | awk 'END{print $1}')" '.blockdevices | .[] | select(.name == $dsk) | .children | .[0] | .name') | grep -i luks > /dev/null 2>&1
	then
		lsblk -sJp | jq -r --arg dsk "$(df -P -h -T "$2" | awk 'END{print $1}')" '.blockdevices | .[] | select(.name == $dsk) | .children | .[0] | .name'
	else
		echo "luks_none"
	fi
elif [[ $1 == "encrypt-uuid" ]]
then
	if blkid -o value -s TYPE $(lsblk -sJp | jq -r --arg dsk "$(df -P -h -T "$2" | awk 'END{print $1}')" '.blockdevices | .[] | select(.name == $dsk) | .children | .[0] | .name') | grep -i luks > /dev/null 2>&1
	then
		blkid "$(lsblk -sJp | jq -r --arg dsk "$(df -P -h -T "$2" | awk 'END{print $1}')" '.blockdevices | .[] | select(.name == $dsk) | .children | .[0] | .name')" -s UUID -o value
	else
		echo "luks_none"
	fi
elif [[ $1 == "encrypt-name" ]]
then
	if blkid -o value -s TYPE $(lsblk -sJp | jq -r --arg dsk "$(df -P -h -T "$2" | awk 'END{print $1}')" '.blockdevices | .[] | select(.name == $dsk) | .children | .[0] | .name') | grep -i luks > /dev/null 2>&1
	then
		 df -P -h -T "$2" | awk 'END{print $1}' | awk -F '/dev/mapper/' '{print $2}'
	else
		echo "luks_none"
	fi
else
	echo "invalid first args not in: part, block, uuid, encrypt-part, encrypt-uuid, encrypt-name" && exit 1
fi

