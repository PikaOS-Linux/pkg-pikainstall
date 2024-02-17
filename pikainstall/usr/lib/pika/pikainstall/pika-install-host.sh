#! /bin/bash
mkdir -pv "$1"/media/cdrom
mount --bind /cdrom "$1"/media/cdrom
mount --rbind /dev "$1"/dev
mount --rbind /dev/pts "$1"/dev/pts
mount --rbind /proc "$1"/proc
mount --rbind /sys "$1"/sys
mount --rbind /run "$1"/run
rm -rfv "$1"/boot/*arch*
mkdir -p "$1"/var/cache/apt/archives
cp -rvf /cdrom/pool/main/* "$1"/var/cache/apt/archives/
mkdir -pv "$1"/usr/lib/pika/pikainstall/
cp -rvf /usr/lib/pika/pikainstall/pika-install-chroot.sh "$1"/usr/lib/pika/pikainstall/
chroot "$1" /bin/bash -c "/usr/lib/pika/pikainstall/pika-install-chroot.sh"
if [ -f /var/albius-crypttab-manual.sh ]
then
	chmod +x /var/albius-crypttab-manual.sh
	/var/albius-crypttab-manual.sh
fi
if [ -f /tmp/pika-installer-gtk4-swaplist ]
then
	for i in $(cat /tmp/pika-installer-gtk4-swaplist)
	do
		echo "UUID="$(blkid -s UUID -o value $i)" none   swap    sw      0       0" >> "$1"/etc/fstab
	done
fi
