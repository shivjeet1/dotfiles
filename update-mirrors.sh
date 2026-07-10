#!/bin/bash
echo "Scanning and ranking top 5 mirrors by speed..."
reflector --protocol https --latest 50 --sort rate --number 5 --save /etc/pacman.d/mirrorlist

if [ $? -eq 0 ]; then
    echo "Success. Pacman mirrorlist updated."
else
    echo "Error updating mirrors."
fi
