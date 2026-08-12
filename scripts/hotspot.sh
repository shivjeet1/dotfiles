#!/bin/sh

WIFI_IF=$(iw dev | awk '$1=="Interface"{print $2}' | head -n1)

EXT_IF=$(ip -br link show up | awk '$1 ~ /^en|^eth/ {print $1}' | head -n 1)

if [ -z "$EXT_IF" ] || [ -z "$WIFI_IF" ]; then
    echo "Error: Network interfaces not found."
    echo "Internet Source (Ethernet): ${EXT_IF:-None} | Hotspot (Wi-Fi): ${WIFI_IF:-None}"
    exit 1
fi

echo "Sharing internet from $EXT_IF via hotspot on $WIFI_IF..."

iptables -t nat -D POSTROUTING -o "$EXT_IF" -j MASQUERADE 2>/dev/null
iptables -D FORWARD -i "$WIFI_IF" -o "$EXT_IF" -j ACCEPT 2>/dev/null
iptables -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null

iptables -t nat -A POSTROUTING -o "$EXT_IF" -j MASQUERADE
iptables -A FORWARD -i "$WIFI_IF" -o "$EXT_IF" -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

echo "Cleaning up old profiles and freeing the Wi-Fi radio..."
nmcli connection delete arch 2>/dev/null
nmcli device disconnect "$WIFI_IF" 2>/dev/null
sleep 2 

if iw list | grep -q "Band 2"; then
    echo "5GHz hardware detected. Attempting high-speed hotspot..."
    
    if ! nmcli device wifi hotspot ifname "$WIFI_IF" ssid arch password shivam2285k band a channel 36; then
        echo "5GHz setup failed (likely firmware/channel restriction). Falling back to 2.4GHz..."
        nmcli connection delete arch 2>/dev/null
        nmcli device wifi hotspot ifname "$WIFI_IF" ssid arch password shivam2285k
    fi
else
    echo "5GHz not supported/available. Starting 2.4GHz..."
    nmcli device wifi hotspot ifname "$WIFI_IF" ssid arch password shivam2285k
fi
