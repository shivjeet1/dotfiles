#!/bin/bash

DISK_IMG="$HOME/Desktop/win10_drive.qcow2"
WIN_ISO="$HOME/Desktop/en-us_windows_10_enterprise_ltsc_2021_x64_dvd_d289cf96.iso"

if [ ! -f "$DISK_IMG" ]; then
    echo "Creating 50GB disk image..."
    qemu-img create -f qcow2 "$DISK_IMG" 50G
fi

echo "Booting Windows 10..."
qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -cpu host \
  -smp 8 \
  -m 8G \
  -drive file="$DISK_IMG",format=qcow2,if=ide \
  -cdrom "$WIN_ISO" \
  -vga virtio \
  -display gtk,gl=on \
  -usb -device usb-tablet \
  -rtc base=localtime
