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
apt install -y /var/cache/apt/archives/pika-refind-theme*.deb
apt install -y /var/cache/apt/archives/booster*.deb
locale-gen
useradd -m -k -U pikaos
echo pikaos:pikaos | sudo chpasswd
usermod -a -G sudo pikaos
usermod -a -G lpadmin pikaos || true
mkdir -p /etc/gdm3
mkdir -p /etc/sddm.conf.d/
echo '[daemon]\nAutomaticLogin=pikaos\nAutomaticLoginEnable=True' > /etc/gdm3/daemon.conf
echo '[Autologin]\nUser=pikaos\nSession=plasma' > /etc/sddm.conf.d/autologin.conf
mkdir -p /home/pikaos/.config/dconf
chmod 700 /home/pikaos/.config/dconf
mkdir -p /var/lib/AccountsService/users
echo '[User]\nSession=firstsetup' > /var/lib/AccountsService/users/pikaos
mkdir -p /home/pikaos/.config/autostart
cp /usr/share/applications/pika-first-setup.desktop /home/pikaos/.config/autostart
chown -R pikaos:pikaos /home/pikaos
