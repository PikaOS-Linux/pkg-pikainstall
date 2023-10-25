#! /bin/bash
touch /etc/fstab
genfstab -U / | grep -v zram | grep -v portal | grep -v loop > /etc/fstab
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
apt remove casper vanilla-installer -y || true
apt autoremove -y || true
locale-gen || true
useradd -m -k -U pikaos || true
echo pikaos:pikaos | chpasswd || true
usermod -a -G sudo pikaos || true
usermod -a -G lpadmin pikaos || true
mkdir -p /etc/gdm3 || true
mkdir -p /etc/sddm.conf.d/ || true
echo -e '[daemon]\nAutomaticLogin=pikaos\nAutomaticLoginEnable=True' >> /etc/gdm3/custom.conf || true
echo -e '[Autologin]\nUser=pikaos\nSession=plasma' > /etc/sddm.conf.d/zautologin.conf || true
mkdir -p /home/pikaos || true
cp -rvf /etc/skel/.* /home/pikaos/ || true
mkdir -p /home/pikaos/.config/autostart || true
cp /usr/share/applications/pika-first-setup.desktop /home/pikaos/.config/autostart || true
chown -R pikaos:pikaos /home/pikaos || true