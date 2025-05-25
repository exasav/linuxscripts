#!/usr/bin/env bash
# This file sends the content of a folder onto a remote locaction (HD's) using SSH keys
# General variables
hostname=$(hostname)
date=$(date +"%Y-%m-%d_%H-%M-%S")

# Defining SSH key(s)
sshremotetoHDbackup="~/.ssh/id_ed25519_backuptoHD"

# Defining timely backup directory on the current server
localbackupdir=~/backupfilesnuc/*

# Ensure the destination directory exists
mkdir -p $localbackupdir

# Define values for the backup HD remote server
backupserver="backuphd-user@amynashome.onthewifi.com"
backupserverhduser=backuphd-user
backupserverhddestdir=/home/backuphd-user/backupHDFiles

# Syncing the content of the backup directory onto the remote server(s)
rsync -avz -e "ssh -i $sshremotetoHDbackup -p 2223" $localbackupdir $backupserver:$backupserverhddestdir > /dev/null

# Logging the time of syncing
loggingdir_rsync_timely="~/rsync_timelybackup_logging"
mkdir -p $loggingdir_rsync_timely
loggingrsync_timely_file="$loggingdir_rsync_timely/${hostname}_backuprsync_timely.log"
echo "The synchronization of $localbackupdir was successful at $date" >> $loggingrsync_timely_file
backuplogdir_remote_hd="/home/backuphd-user/backupHDFiles/backuplogs_backup"

rsync -e "ssh -i $sshremotetoHDbackup -p 2223" $loggingrsync_timely_file $backupserver:$backuplogdir_remote_hd >> /dev/null
