#! /bin/bash

# Clear fstab
touch /etc/fstab
# Generate fstab entries
genfstab -U / | grep -v zram | grep -v portal | grep -v loop | grep -v cdrom > /etc/fstab
# Remove packages that are only needed for the live session
apt remove casper -y
apt autoremove -y
# Setup Crypttab if needed
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
# Generate locales
locale-gen || true
# Setup keyboard and locales
chmod +x /var/albius-lang_linux.sh
/var/albius-lang_linux.sh
# Setup the refind bootloader
chmod +x /var/albius-refind_linux.sh
/var/albius-refind_linux.sh
refind-install
apt install -y /var/cache/apt/archives/pika-refind-theme*.deb /var/cache/apt/archives/booster*.deb
# EFI workaround for MSI
mkdir -p /boot/efi/EFI/BOOT
cp -vf  /boot/efi/EFI/refind/refind_x64.efi /boot/efi/EFI/BOOT/BOOTX64.EFI
# Remove installer from installed system
apt remove casper vanilla-installer -y || true
apt autoremove -y || true
# Create first setup user
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
