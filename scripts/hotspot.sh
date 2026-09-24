#!/bin/sh

SSID="arch"
PASS="shivam2285k"

WIFI_IF=$(nmcli -t -f DEVICE,TYPE device | awk -F: '$2=="wifi" {print $1}' | head -n 1)

EXT_IF=$(ip route | awk '/default/ {print $5}' | grep -E '^en|^eth' | head -n 1)

cleanup_iptables() {
    if [ -n "$EXT_IF" ] && [ -n "$WIFI_IF" ]; then
        iptables -t nat -D POSTROUTING -o "$EXT_IF" -j MASQUERADE 2>/dev/null
        iptables -D FORWARD -i "$WIFI_IF" -o "$EXT_IF" -j ACCEPT 2>/dev/null
        iptables -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null
    fi
}

if nmcli -t -f NAME connection show --active | grep -qx "$SSID"; then
    echo "Hotspot '$SSID' is currently ACTIVE. Turning it OFF..."
    nmcli connection down "$SSID" 2>/dev/null
    nmcli connection delete "$SSID" 2>/dev/null
    cleanup_iptables
    echo "Hotspot stopped and NAT rules cleared."
    exit 0
fi

if [ -z "$EXT_IF" ] || [ -z "$WIFI_IF" ]; then
    echo "Error: Required network interfaces not found."
    echo "Internet Source (Ethernet): ${EXT_IF:-None} | Hotspot (Wi-Fi): ${WIFI_IF:-None}"
    exit 1
fi

echo "Starting hotspot: Sharing internet from $EXT_IF via $WIFI_IF..."

cleanup_iptables
nmcli connection delete "$SSID" 2>/dev/null
nmcli device disconnect "$WIFI_IF" 2>/dev/null
sleep 2 

iptables -t nat -A POSTROUTING -o "$EXT_IF" -j MASQUERADE
iptables -A FORWARD -i "$WIFI_IF" -o "$EXT_IF" -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

if iw list 2>/dev/null | grep -q "Band 2"; then
    echo "5GHz hardware detected. Attempting high-speed hotspot..."
    
    if ! nmcli device wifi hotspot ifname "$WIFI_IF" ssid "$SSID" password "$PASS" band a channel 36; then
        echo "5GHz setup failed (likely firmware/channel restriction). Falling back to 2.4GHz..."
        nmcli connection delete "$SSID" 2>/dev/null
        nmcli device wifi hotspot ifname "$WIFI_IF" ssid "$SSID" password "$PASS"
    fi
else
    echo "5GHz not supported/available. Starting 2.4GHz..."
    nmcli device wifi hotspot ifname "$WIFI_IF" ssid "$SSID" password "$PASS"
fi

echo "Hotspot '$SSID' is now ON."
