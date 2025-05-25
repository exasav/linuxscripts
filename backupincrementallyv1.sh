#!/usr/bin/env bash
# This script incrementally backups (a) certain file(s) and sends them to a specific backup server + logs it.
# General variables
hostname=$(hostname)
date=$(date +"%Y-%m-%d_%H-%M-%S")

# Defining SSH key(s)
sshlocalbackupkey="~/.ssh/id_ed25519_backupLocallyOnNUC"

# Defining timely backup directory on the current server 
destination_dir=~/config_backups_${hostname}/config_backups_${hostname}_inc

# Defining file paths and names for backup
file1_tobebackedup="/etc/nginx/sites-available/exasav.com"
file1_backedup=$(basename $file1_tobebackedup)_inc.bak

# Ensure the destination directory exists
mkdir -p $destination_dir

## Persistent backup / Backing up by date

# Copying the config file(s) with the exact name
rsync -a $file1_tobebackedup $destination_dir/$file1_backedup

# Defining file(s) that'll be rsynced

backupserverlocal="backup-user@backup"
backupserverdestdir=/home/backup-user/backupfilesnuc/configfile_backups/${hostname}_backupdir/${hostname}_backupdir_inc

rsync -avz -e "ssh -i $sshlocalbackupkey" $destination_dir/* $backupserverlocal:$backupserverdestdir >> /dev/null

## Logging
# Defining and creating directory for timely backups

logfiledir_timely=~/backuplogs_${hostname}
mkdir -p $logfiledir_timely
logfile_timely_local=${hostname}_backuptimely.log

# Successful backup

echo "Incremental backup was successful from $hostname at $date" >> $logfiledir_timely/$logfile_timely_local

backuplogs_file=~/backuplogs_${hostname}/$logfile_timely_local
backuplogs_dirNUC=/home/backup-user/backupfilesnuc/backuplogs_backup

rsync -avz -e "ssh -i $sshlocalbackupkey" $backuplogs_file $backupserverlocal:$backuplogs_dirNUC >> /dev/null
