+++
date = ""
title = "Backing up the home"
draft = true
+++

For years my personal backup strategy consisted of ocassionally (very..) using Windows Backup to an external drive and using cloud storage - it's arguable whether or not this classifies as backup, but nevertheless it's better than nothing and has other benefits like portability. As the network at home has gotten more complicated though, this backup strategy quickly became untenable. In addition to personal machines, I've now got an Ubuntu box running various services, a Raspberry Pi for PiHole, another Pi for audio streaming, and another small computer serving as a router running OPNSense. Basically enough stuff that it would really suck to have to re-configure without an up-to-date backup, even if my documents are relatively safe in the cloud. So, time to level up, but only just one level - attaching an 8TB external USB drive to the Ubuntu box and using it as a target for backups. Eventually I'd like to upgrade to a dedicated NAS device, but that's an expense for another time.

# Why backup

There are a lot of [threats to data](https://www.unitrends.com/blog/backup-what-causes-data-loss):
- yourself
- software
- storage device failure
- natural disasters
- theft
- malware, ransomware

These are all mostly low probability events, but they are non-zero and if you've ever experienced the feeling of panic associated with the clicking noises made by a dying drive, or the ..nothingness of a dead solid state drive, you probably recognize that having a backup of some sort is important. It's also important to understand what your chosen method of data backup is guarding against. Using an external drive will protect you from your computer's drive dying, but not if they both get taken out by a lightning strike or fire. To ensure that you're reasonably safe, data backup experts recommend the ["3-2-1" strategy](https://www.backblaze.com/blog/the-3-2-1-backup-strategy/) which means that you should have 3 copies of your data, 2 of which are local but on different media (or devices), and 1 of which is off-site.

Now that I've covered that, what follows are my notes on how I'm backing up my devices at home.

# Setting up the USB drive

After connecting the drive to the Ubuntu machine, it shows up as `sdc` (eg. `lsblk`). I then deleted all the existing partitions using `fdisk` which in hindsight I'm not sure was necessary. Below are commands for making a new ext4 partition with `parted`.

```
sudo parted /dev/sdc mklabel gpt
sudo parted --align optimal /dev/sdc mkpart primary ext4 0% 100%
sudo mkfs.ext4 /dev/sdc1
```

Then, to make sure that it gets mounted on boot to `/mnt/external` (remember to make this directory), I added it to `/etc/fstab` using the UUID that is associated with the new partition, which you can find using `lsblk -f`. The fstab entry looks like this (using a randomly generated UUID):

```
UUID=c18cc71b-09fd-4102-b8ec-8a408dd5484a /mnt/external ext4 defaults 0 0
```

Finally, `sudo mount -a` to mount the new partition 

# Backing up Ubuntu Server with Borg

I chose borg (version 1.1.15) for this purpose because it de-duplicates and compresses data at a chunk level, allowing for incremental backups with storage requirements. Another very similar tool is `restic`, but I've avoided it for now after reading about potential issues with memory usage - it seems like these problems are actively being worked on. I created a borg repository on the external:

```
sudo borg init -e repokey-blake2 --make-parent-dirs /mnt/external/borg/small
```

Then, I filled in this example script (below) from the `borg` documentation with my own information, modifying some options such as opting for `zlib` over `lz4` for the increased compression, and adding some additional folders to exclude.

```bash
#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=ssh://username@example.com:2022/~/backup/main

# See the section "Passphrase notes" for more infos.
export BORG_PASSPHRASE='XYZl0ngandsecurepa_55_phrasea&&123'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude '/home/*/.cache/*'    \
    --exclude '/var/cache/*'        \
    --exclude '/var/tmp/*'          \
                                    \
    ::'{hostname}-{now}'            \
    /etc                            \
    /home                           \
    /root                           \
    /var                            \

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}
```

Then, to execute this every night, add the following entry to cron:

```

```


# Backing up the Raspberry Pi

This is slightly more involved since I've chosen to back up in [pull mode](https://borgbackup.readthedocs.io/en/stable/deployment/pull-backup.html#) to avoid having the 

# Backing up OPNSense

Backing up OPNSense is relatively straightforward - you just need the config.xml file. The `os-api-backup` package helps by providing an API for downloading this file. 

# Backing up personal machines

At time of writing this is still effectivelly the 

# Backing up the  backups

3-2-1

# Final words

This is probably overk

Some alternatives that are worth considering:
- Back everything up with [Backblaze](https://backblaze.com) or similar tool. Downside: costs more money
- Having less stuff. I could cut down on devices by virtualizing more
- Use [Ansible](https://ansible.com) or some other configuration management tool to configure all the servers, and store those files somewhere like GitHub. This of course won't back up user data, but in my case, many of the services that I run don't really generate important data and I'm just trying to avoid having to re-configure things in the event of some failure.
- 