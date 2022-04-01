#!/bin/sh

op_result=0

#KMS files for arm and amd
AMD_KMS_CONF_FILE=/mnt/loader/entries/gridos.conf
ARM_KMS_CONF_FILE=/mnt/config.txt

DATE=$(TZ='Europe/Stockholm' date +%Y-%b-%d.%H:%M:%S)
HOME_OMBORI=$(getent passwd ombori | cut -d: -f6)

#Boot devices for arm and amd (diffrence comes from using disk and sd card)
AMD_BOOT=/dev/sda1
ARM_BOOT=/dev/mmcblk0p1

SYSTEM_ARCH=$(dpkg --print-architecture)
echo "System Architecture: $SYSTEM_ARCH"

#AMD64 arch systems*************************************************************************
if [ "$SYSTEM_ARCH" = "amd64" ] ; then
    mount $AMD_BOOT /mnt

    #check the files existence after mount
    if [ -f "$AMD_KMS_CONF_FILE" ] ; then
        echo " + /dev/sda1 mounted succesful!"

        #verify it is KMS file with checking "initrd.img" keyword is there
        if grep -q "initrd.img" "$AMD_KMS_CONF_FILE" ; then
            echo " + KMS file verified succesful!"
            #backup the old KMS file for any restore operation
            cp "$AMD_KMS_CONF_FILE" "$HOME_OMBORI/.old_gridos.conf-$DATE"

            #Check the settings applied before
            if grep -q "hdmi_force_hotplug=1\|hdmi_group=1\|hdmi_mode=16" "$AMD_KMS_CONF_FILE" ; then
                #ADD required KMS settings at the end of the KMS file
                sed -i '$a hdmi_force_hotplug=1\nhdmi_group=1\nhdmi_mode=16' "$AMD_KMS_CONF_FILE" && op_result=1
            else
                echo " - ERR! The changes are applied before!"
                echo " - No change applied!"
            fi

            

        else
            echo " - ERR! KMS file could NOT verified!!"
            echo " - Contact with Ombori Tech team!"
            exit 1
        fi
    else
        echo " - ERR! /dev/sda1 CANT mount!"
        echo " - Contact with Ombori Tech team!"
        exit 1
    fi

#ARM64 arch systems**************************************************************************
elif [ "$SYSTEM_ARCH" = "arm64" ] ; then
    mount $ARM_BOOT /mnt

    #check the files existence after mount
    if [ -f "$ARM_KMS_CONF_FILE" ] ; then
        echo " + /dev/mmcblk0p1 mounted succesful!"

        #verify it is KMS file with checking "initrd.img" keyword is there
        if grep -q "initrd.img" "$ARM_KMS_CONF_FILE" ; then
            echo " + KMS file verified succesful!"
            #backup the old KMS file for any restore operation
            cp "$ARM_KMS_CONF_FILE" "$HOME_OMBORI/.old_config.txt-$DATE"
            #ADD required KMS settings at the end of the KMS file

            #Check the settings applied before
            if grep -q "hdmi_force_hotplug=1\|hdmi_group=1\|hdmi_mode=16" "$ARM_KMS_CONF_FILE" ; then
                #ADD required KMS settings at the end of the KMS file
                sed -i '$a hdmi_force_hotplug=1\nhdmi_group=1\nhdmi_mode=16' "$ARM_KMS_CONF_FILE" && op_result=1
            else
                echo " - ERR! The changes are applied before!"
                echo " - No change applied!"
            fi

            sed -i '$a hdmi_force_hotplug=1\nhdmi_group=1\hdmi_mode=16' "$ARM_KMS_CONF_FILE"

        else
            echo " - ERR! KMS file could NOT verified!!"
            echo " - Contact with Ombori Tech team!"
            exit 1
        fi
    else
        echo " - ERR! /dev/mmcblk0p1 CAN'T mount!"
        echo " - Contact with Ombori Tech team!"
        exit 1
    fi
fi

if [ $op_result = 1 ] ; then
    echo echo "Fix is Succesful. A reboot is required!"
fi