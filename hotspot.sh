#!/bin/sh

iptables -t nat -A POSTROUTING -o enp0s31f6 -j MASQUERADE
iptables -A FORWARD -i wlp2s0 -o enp0s31f6 -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
nmcli con down arch
nmcli device wifi hotspot ifname wlp2s0 ssid arch password shivam2285k

