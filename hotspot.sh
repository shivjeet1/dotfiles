#!/bin/sh

sudo iptables -t nat -A POSTROUTING -o enp0s31f6 -j MASQUERADE
sudo iptables -A FORWARD -i wlp2s0 -o enp0s31f6 -j ACCEPT\
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo nmcli con down shivam
nmcli con down shivam
sudo nmcli device wifi hotspot ifname wlp2s0 ssid shivam password shivam2285k

