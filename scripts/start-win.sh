#!/bin/bash

DISK_IMG="$HOME/Desktop/win10_drive.qcow2"

# Chicony Integrated Camera (from lsusb: 04f2:b756)
CAM_VENDOR_ID="0x04f2"
CAM_PRODUCT_ID="0xb756"

qemu-system-x86_64 \
  -enable-kvm \
  -machine q35 \
  -cpu host \
  -smp 8 \
  -m 8G \
  -drive file="$DISK_IMG",format=qcow2,if=ide \
  -vga virtio \
  -display gtk,gl=on \
  -usb -device usb-tablet \
  -rtc base=localtime \
  -device virtio-serial-pci \
  -chardev qemu-vdagent,id=vdagent,name=vdagent,clipboard=on \
  -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
  -audiodev pipewire,id=audio0 \
  -device ich9-intel-hda \
  -device hda-duplex,audiodev=audio0 \
  -device usb-host,vendorid="$CAM_VENDOR_ID",productid="$CAM_PRODUCT_ID"
