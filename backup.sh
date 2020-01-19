#!/bin/sh -e
# made with help of the following tutorials:
# https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md
# https://www.raspberrypi.org/documentation/remote-access/vnc/

# need root for execution
if [ "$(id -un)" != "root" ]; then
  echo "Please run this script as root!"
  exit
fi

# install packages
echo "Installing packages..."
PACKAGES="dnsmasq hostapd realvnc-vnc-server"
apt-get update && apt-get upgrade -y
apt-get install $PACKAGES -y

# stop them since the config files are not ready yet
systemctl stop dnsmasq
systemctl stop hostapd

# configure static ip
echo "Configuring static ip via contents of provided dhcpcd.conf file..."
cat config/dhcpcd.conf >> /etc/dhcpcd.conf
service dhcpcd restart

# configure dhcp server
echo "Configuring dhcp server via contents of provided dnsmasq.conf file..."
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cat config/dnsmasq.conf > /etc/dnsmasq.conf
systemctl start dnsmasq
systemctl reload dnsmasq

# configure access point host software
echo "Configuring access point..."
cat config/hostapd.conf > /etc/hostapd/hostapd.conf 

# tell the system where to find the config file above
sed -i 's@#DAEMON_CONF=.*@DAEMON_CONF="/etc/hostapd/hostapd.conf"@g' /etc/default/hostapd

# enable and start hostapd
echo "Enabling and starting hostapd..."
systemctl unmask hostapd
systemctl enable hostapd
systemctl start hostapd

# add routing and masquerade
echo "Adding routes and masquerade..."
sed -i 's@#net.ipv4.ip_forward=.*@net.ipv4.ip_forward=1@g' /etc/sysctl.conf
iptables -t nat -A  POSTROUTING -o wlan0 -j MASQUERADE
sh -c "iptables-save > /etc/iptables.ipv4.nat"

if [ -e /etc/rc.local ]
then
  LOCALFILE="/etc/rc.local"
  sed -i 's@exit 0@iptables-restore < /etc/iptables.ipv4.nat@g' $LOCALFILE
  echo "exit 0" >> $LOCALFILE
else
  echo "ERROR: missing Locale!"
fi

# set vnc resolution for iPad aspect ratio
echo "Config VNC..."
BOOTCONFIG="/boot/config.txt"
sed -i "s@#framebuffer_width=.*@framebuffer_width=1600@g" $BOOTCONFIG
sed -i "s@#framebuffer_height=.*@framebuffer_height=1200@g" $BOOTCONFIG

# set vnc autostart on boot
LOCALFILE="/etc/rc.local"
sed -i 's@exit 0@systemctl start vncserver-x11-serviced@g' $LOCALFILE
echo "exit 0" >> $LOCALFILE

# enable vnc
systemctl enable vncserver-x11-serviced.service

echo "SUCCESSFULY INSTALLED!"

# reboot in one minute
echo "Reboot in 1 minute!"
shutdown -r 1