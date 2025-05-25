#!/usr/bin/env bash
# This script persistently backups (a) certain file(s) by adding a date to their names and sends them to a specific backup server + logs it.
# General variables
hostname=$(hostname)
date=$(date +"%Y-%m-%d_%H-%M-%S")

# Defining SSH key(s)
sshlocalbackup="~/.ssh/id_ed25519_backupLocallyOnNUC"

# Defining timely backup directory on the current server 
destination_dir=~/config_backups_${hostname}/config_backups_${hostname}_pers

# Defining file paths and names for backup
file1_tobebackedup="/etc/nginx/sites-available/exasav.com"
file1_backedup=$(basename $file1_tobebackedup)_${date}.bak

# Ensure the destination directory exists
mkdir -p $destination_dir

## Persistent backup / Backing up by date

# Copying the config file(s) with the exact name
cp $file1_tobebackedup $destination_dir/$file1_backedup

# Defining backup directories on the (local) backup server
backupserver="backup-user@backup"
backupNUC_dir1=/home/backup-user/backupfilesnuc/configfile_backups/${hostname}_backupdir/${hostname}_backupdir_per
newly_copied_backupfile1=$destination_dir/$file1_backedup

# Send the copy to the backupNUC server

scp -i $sshlocalbackup $newly_copied_backupfile1 $backupserver:$backupNUC_dir1 >> /dev/null

## Logging
# Defining and creating directory for timely backups
logfiledir_timely=~/backuplogs_${hostname}
mkdir -p $logfiledir_timely
logfile_timely_local=${hostname}_backuptimely.log

# Successful backup

echo "Timely backup was successful from $hostname at $date" >> $logfiledir_timely/$logfile_timely_local

logfile_timely_tbsent=$logfiledir_timely/$logfile_timely_local

backuplogs_dirNUC=/home/backup-user/backupfilesnuc/backuplogs_backup

rsync -e "ssh -i $sshlocalbackup" $logfile_timely_tbsent $backupserver:$backuplogs_dirNUC >> /dev/null
