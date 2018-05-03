#!/bin/bash

# Mount NTFS (R/W) on macOS
# To use with OSXFUSE and NTFS-3G
# https://github.com/osxfuse/osxfuse/wiki
# https://github.com/osxfuse/osxfuse/wiki/NTFS-3G

COLOR="036"
MOUNT_DIR="/Volumes/NTFS"

# list external disks and partitions
printf "\e[${COLOR}m"
printf "The following external partition(s) were found:\n"
printf "\e[0m"
diskutil list external
printf "\n"

# ask for the partition
printf "\e[${COLOR}m"
printf "Enter the "
printf "\e[4;${COLOR}m"
printf "IDENTIFIER"
printf "\e[0m"
printf "\e[${COLOR}m"
printf " of the NTFS partition to mount and press return (example: disk2s3):\n>"
printf "\e[0m"
read -r PARTITION
printf "\n"

# check if empty
if [ -z "$PARTITION" ]
then
   printf "Cancel\n\n"
   exit
fi

# check if partition exist
PARTITION="/dev/$PARTITION"

#if [ ! -f "$PARTITION" ]
#then
#   printf "$PARTITION does not exist\n"
#   printf "Cancel\n\n"
#   exit
#fi

# ask to confirm
printf "\e[${COLOR}m"
printf "Do you want to mount "
printf "\e[0m"
printf "\e[4;${COLOR}m"
printf $PARTITION
printf "\e[0m"
printf "\e[${COLOR}m"
printf " to /Volumes/NTFS (y/n)?\n>"
printf "\e[0m"
read -r YORN
printf "\n"

# if not confirmed
if [ $YORN != "y" ]; then
   printf "Cancel\n"
   exit
fi

# if the partition is already mounted
if [ $(mount | grep -c $PARTITION) = 1 ]; then
   # unmount it
   printf "\e[${COLOR}m"
   printf "$PARTITION is already mounted\n"
   printf "Trying to unmount\n"
   printf "\e[0m"
   diskutil unmount $PARTITION
   printf "\n"
fi


# if the mount destination does not exist
if [ ! -d "$MONT_DIR" ]; then
   # try to create the folder
   printf "\e[${COLOR}m"
   printf "$MOUNT_DIR does not exist\n"
   printf "Trying to create /Volumes/NTFS\n"
   printf "\e[0m"
   sudo mkdir $MOUNT_DIR
   printf "\n"
fi

# mount and open
printf "\e[${COLOR}m"
printf "Trying to mount $PARTITION to $MOUNT_DIR\n"
printf "\e[0m"
sudo /usr/local/sbin/mount_ntfs -olocal -oallow_other $PARTITION $MOUNT_DIR
open $MOUNT_DIR
