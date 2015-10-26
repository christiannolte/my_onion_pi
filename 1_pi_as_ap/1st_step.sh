#!/bin/bash
sudo apt-get update
sudo apt-get install hostapd isc-dhcp-server
sudo cp configs/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo cp configs/isc-dhcp-server /etc/default/isc-shcp-server
sudo ifdown wlan0
sudo cp configs/interfaces /etc/network/interfaces
sudo cp configs/hostapd.conf /etc/hostapd/hostapd.conf
sudo cp configs/hostapd /etc/default/hostapd
sudo cp configs/sysctl.conf /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo iptables -t nat -S
sudo iptables -S

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

sudo wget http://adafruit-download.s3.amazonaws.com/adafruit_hostapd_14128.zip
unzip adafruit_hostapd_14128.zip
sudo mv /usr/sbin/hostapd /usr/sbin/hostapd.ORIG
sudo mv hostapd /usr/sbin
sudo chmod 755 /usr/sbin/hostapd
sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf

sudo service hostapd start 
sudo service isc-dhcp-server start

sudo service hostapd status
sudo service isc-dhcp-server status
 