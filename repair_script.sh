#!/bin/sh

#KMS files for arm and amd
AMD_KMS_CONF_FILE=/mnt/loader/entries/gridos.conf
ARM_KMS_CONF_FILE=/mnt/config.txt

DATE=`TZ='Europe/Stockholm' date +%Y-%b-%d.%H:%M:%S`
HOME_OMBORI=`getent passwd ombori | cut -d: -f6`

#Boot devices for arm and amd
AMD_BOOT=/dev/sda1
ARM_BOOT=/dev/mmcblk0p1

SYSTEM_ARCH=`dpkg --print-architecture`
echo "System Architecture: $SYSTEM_ARCH"

if [[ $SYSTEM_ARCH == "amd64" ]]

    mount /dev/sda1 /mnt
    if [ -f "$AMD_KMS_CONF_FILE" ]; then
        echo "/dev/sda1 mounted succesful!"

        if [ grep -q "initrd.img" $AMD_KMS_CONF_FILE ]; then
            echo "KMS file verified succesful!"
            cp $KMS_CONF $HOME_OMBORI/.old_gridos.conf-$DATE


        else
            echo "ERR! KMS file could NOT verified!!"
            echo "Contact with Ombori Tech team!"
            exit 1
        fi
    else
        echo "ERR! /dev/sda1 CAN'T mount!"
        echo "Contact with Ombori Tech team!"
        exit 1
    fi
fi