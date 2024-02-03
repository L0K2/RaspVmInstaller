#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <nome_da_imagem> <tamanho_em_G>"
    exit 1
fi

RASP_IMG="$1"
SIZE="$2"

mkdir piboot

sudo mount -v -o offset=$((512*8192)) "$RASP_IMG" piboot

cd piboot

cp bcm2710-rpi-3-b.dtb kernel8.img ../

cd ..

sudo umount piboot

qemu-img resize -f raw "$RASP_IMG" "$SIZE"

qemu-system-aarch64 -machine raspi3b -cpu cortex-a53 -smp 4 -m 1G -kernel kernel8.img -dtb bcm2710-rpi-3-b.dtb -sd "$RASP_IMG" -append "root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" -usbdevice keyboard -usbdevice mouse -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::2022-:22

