+++
date = ""
draft = true
title = "Live clone a drive in Ubuntu"

+++
I have a small server at home running Ubuntu Server 18.04 that I was looking to upgrade to an SSD but I didn't want to reinstall the OS, and I wanted to keep downtime to a minimum. I researched several techniques and Clonezilla and `dd` popped up a lot but it seemed like the most reliable use either of these methods required booting from separate media which means downtime. I probably would've forged ahead with careful use of `dd` while the system was online, but then I found [weresync](https://github.com/DonyorM/weresync) - a tool that claims to do everything I want whose main purpose seems to be allowing one to maintain bootable backup clones. What's more, `weresync` doesn't require that you resize your partitions, it works as long as the destination clone can fit all of the *data* from the originating drive.

My source drive is a 250GB hard drive on `/dev/sda` with the following partition layout.

```bash
$ lsblk -l
NAME                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0                   7:0    0    89M  1 loop /snap/core/[redacted]
loop1                   7:1    0  89.1M  1 loop /snap/core/[redacted]
sda                     8:0    0 232.9G  0 disk
sda1                    8:1    0   512M  0 part /boot/efi
sda2                    8:2    0     1G  0 part /boot
sda3                    8:3    0 231.4G  0 part
sdb                     8:16   0 223.6G  0 disk
ubuntu--vg-ubuntu--lv 253:0    0    50G  0 lvm  /
ubuntu--vg-lv--0      253:1    0 181.4G  0 lvm  /home
```

Note that I had some trouble installing from pip and the `apt` version was a old.

```bash
sudo apt install python3-pydbus # dependency
wget https://github.com/DonyorM/weresync/releases/download/v1.1.5/weresync-doc_1.1.5-1_all.deb
sudo dpkg -i weresync-doc_1.1.5-1_all.deb
sudo apt install -f

sudo weresync-daemon > /dev/null 2>&1 &
weresync -C -l ubuntu-vg -B2 -E1 /dev/sda /dev/sdb

```
`-C`
: partition new drive

`l ubuntu-vg`
: I set this because I'm using LVM and my volume group is called ubuntu-vg

`-B2`
: My `/boot` partition is the second one on `/dev/sda`

`-E1`
: I'm using EFI and it is on the first partition on `/dev/sda`



So you can get a sense of the other command line options:

```bash
$ sudo weresync --help
usage: weresync [-h] [-C] [-s SOURCE_MASK] [-t TARGET_MASK]
                [-e EXCLUDED_PARTITIONS] [-b] [-g ROOT_PARTITION]
                [-B BOOT_PARTITION] [-E EFI_PARTITION] [-m SOURCE_MOUNT]
                [-M TARGET_MOUNT] [-r RSYNC_ARGS] [-L BOOTLOADER]
                [-l LVM [LVM ...]] [-v | -d]
                source target

positional arguments:
  source                The drive to copy data from. This drive will not be
                        edited.
  target                The drive to copy data to. ALL DATA ON THIS DRIVE WILL
                        BE ERASED.

optional arguments:
  -h, --help            show this help message and exit
  -C, --check-and-partition
                        Check if partitions are valid and re-partition drive
                        to proper partitions if they are not.
  -s SOURCE_MASK, --source-mask SOURCE_MASK
                        A string of format '{0}{1}' where {0} represents drive
                        identifier and {1} represents partition number to
                        point to partition block files for the source drive.
  -t TARGET_MASK, --target-mask TARGET_MASK
                        A string of format '{0}{1}' where {0} represents drive
                        identifier and {1} represents partition number to
                        point to partition block files for the target drive.
  -e EXCLUDED_PARTITIONS, --excluded-partitions EXCLUDED_PARTITIONS
                        A comment separated list of partitions of the source
                        drive to apply no actions on.perated list of
                        partitions of the source drive to apply no actions on.
  -b, --break-on-error  Causes program to break whenever a partition cannot be
                        copied, including uncopyable partitions such as swap
                        files. Not recommended.
  -g ROOT_PARTITION, --root-partition ROOT_PARTITION
                        The partition mounted on /.
  -B BOOT_PARTITION, --boot-partition BOOT_PARTITION
                        Partition which should be mounted on /boot
  -E EFI_PARTITION, --efi-partition EFI_PARTITION
                        Partition which should be mounted on /boot/efi
  -m SOURCE_MOUNT, --source-mount SOURCE_MOUNT
                        Folder where partitions from the source drive should
                        be mounted.
  -M TARGET_MOUNT, --target-mount TARGET_MOUNT
                        Folder where partitions from source drive should be
                        mounted.
  -r RSYNC_ARGS, --rsync-args RSYNC_ARGS
                        List of arguments passed to rsync. Defaults to: -aAXxH
                        --delete
  -L BOOTLOADER, --bootloader BOOTLOADER
                        Passed to decide what boootloader plugin to use. See
                        below for list of plugins. Defaults to simply changing
                        the UUIDs of files in /boot.
  -l LVM [LVM ...], --lvm LVM [LVM ...]
                        The name of the source logical volume.
  -v, --verbose         Prints expanded output.
  -d, --debug           Prints large output. Mainly helpful for developers.

Bootloader plugins found: uuid_copy, grub2, syslinux
```