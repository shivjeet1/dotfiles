#!/bin/bash

DISK_IMG="$HOME/Desktop/win10_drive.qcow2"

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
  -device virtserialport,chardev=vdagent,name=com.redhat.spice.0
