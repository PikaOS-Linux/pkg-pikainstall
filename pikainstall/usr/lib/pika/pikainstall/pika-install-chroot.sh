#! /bin/bash
apt remove casper -y
apt autoremove -y
if [ -f /var/albius-crypttab-root.sh ]
then
	chmod +x /var/albius-crypttab-root.sh
	/var/albius-crypttab-root.sh
fi
if [ -f /var/albius-crypttab.sh ]
then
	chmod +x /var/albius-crypttab.sh
	/var/albius-crypttab.sh
fi
chmod +x /var/albius-refind_linux.sh
/var/albius-refind_linux.sh
refind-install
apt install -y /var/cache/apt/archives/pika-refind-theme*.deb /var/cache/apt/archives/booster*.deb
apt remove casper vanilla-installer -y
apt autoremove -y
locale-gen
useradd -m -k -U pikaos
echo pikaos:pikaos | sudo chpasswd
usermod -a -G sudo pikaos
usermod -a -G lpadmin pikaos || true
mkdir -p /etc/gdm3
mkdir -p /etc/sddm.conf.d/
echo -e '[daemon]\nAutomaticLogin=pikaos\nAutomaticLoginEnable=True' >> /etc/gdm3/custom.conf
echo -e '[Autologin]\nUser=pikaos\nSession=plasma' > /etc/sddm.conf.d/autologin.conf
mkdir -p /home/pikaos
cp -rvf /etc/skel/.* /home/pikaos/ || true
mkdir -p /home/pikaos/.config/autostart
cp /usr/share/applications/pika-first-setup.desktop /home/pikaos/.config/autostart
chown -R pikaos:pikaos /home/pikaos