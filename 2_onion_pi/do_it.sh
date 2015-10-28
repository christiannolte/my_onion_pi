#!/bin/bash
echo "Updating system"
sudo apt-get update
echo "installing tor"
sudo apt-get install tor
sudo cp configs/torrc /etc/tor/torrc
sudo service hostapd stop
sudo cp configs/hostapd.conf /etc/hostapd/hostapd.conf
sudo service hostapd start
sudo service hostapd status
echo "setup firewall rules"
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 22 -j REDIRECT --to-ports 22
sudo iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j REDIRECT --to-ports 53
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --syn -j REDIRECT --to-ports 9040
sudo iptables -t nat -L
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
sudo touch /var/log/tor/notices.log
sudo chown debian-tor /var/log/tor/notices.log
sudo chmod 644 /var/log/tor/notices.log
ls -l /var/log/tor
echo "starting tor"
sudo service tor start
sudo service tor status
sudo update-rc.d tor enable
sudo reboot