#! /bin/bash
apt remove casper -y
apt autoremove -y
if [ -f /tmp/albius-crypttab-root.sh ]
then
	chmod +x /tmp/albius-crypttab-root.sh
	/tmp/albius-crypttab-root.sh
fi
if [ -f /tmp/albius-crypttab.sh ]
then
	chmod +x /tmp/albius-crypttab.sh
	/tmp/albius-crypttab.sh
fi
chmod +x /tmp/albius-refind_linux.sh
/tmp/albius-refind_linux.sh
refind-install
apt install -y /var/cache/apt/archives/pika-refind-theme*.deb
apt install -y /var/cache/apt/archives/booster*.deb
locale-gen
useradd -m -k -U pikaos
echo "pikaos"| passwd --stdin pikaos
mkdir -p /var/lib/AccountsService/users
echo '[User]\nSession=firstsetup' > /var/lib/AccountsService/users/pikaos
mkdir -p /home/pikaos/.config/autostart
cp /usr/share/applications/pika-first-setup.desktop /home/pikaos/.config/autostart
chown -R pikaos:pikaos /home/pikaos
