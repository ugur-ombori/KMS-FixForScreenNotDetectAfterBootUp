#!/bin/sh

#KMS files for arm and amd
AMD_KMS_CONF_FILE=/mnt/loader/entries/gridos.conf
ARM_KMS_CONF_FILE=/mnt/config.txt

DATE=`TZ='Europe/Stockholm' date +%Y-%b-%d.%H:%M:%S`
HOME_OMBORI=`getent passwd ombori | cut -d: -f6`

#Boot devices for arm and amd (diffrence comes from using disk and sd card)
AMD_BOOT=/dev/sda1
ARM_BOOT=/dev/mmcblk0p1

SYSTEM_ARCH=`dpkg --print-architecture`
echo "System Architecture: $SYSTEM_ARCH"

#AMD64 arch systems
if [ "$SYSTEM_ARCH" == "amd64" ] then

    mount /dev/sda1 /mnt
    if [ -f "$AMD_KMS_CONF_FILE" ]; then
        echo "/dev/sda1 mounted succesful!"

        if [ grep -q "initrd.img" $AMD_KMS_CONF_FILE ]; then
            echo "KMS file verified succesful!"
            #TODO change with mv
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
#ARM64 arch systems
elif [ "$SYSTEM_ARCH" == "arm64" ] then

    mount /dev/mmcblk0p1 /mnt
    if [ -f "$ARM_KMS_CONF_FILE" ]; then
        echo "/dev/mmcblk0p1 mounted succesful!"

        if [ grep -q "initrd.img" $ARM_KMS_CONF_FILE ]; then
            echo "KMS file verified succesful!"
            #TODO change with mv
            cp $ARM_KMS_CONF_FILE $HOME_OMBORI/.old_config.txt-$DATE


        else
            echo "ERR! KMS file could NOT verified!!"
            echo "Contact with Ombori Tech team!"
            exit 1
        fi
    else
        echo "ERR! /dev/mmcblk0p1 CAN'T mount!"
        echo "Contact with Ombori Tech team!"
        exit 1
    fi
fi