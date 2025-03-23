#!/bin/bash

# Ask for password for current user
echo -n "Enter a new password for the current user ($(whoami)): "
read -s USERPASS
echo
sleep 1

# Ask for password for root user
echo -n "Enter a new password for the root user: "
read -s ROOTPASS
echo
sleep 1

# Get current username
CURRENT_USER=$(whoami)

# Ask for sudo password just once here
echo -n "Enter your current sudo password: "
read -s SUDOPASS
echo

# Set password for current user
echo "$SUDOPASS" | sudo -S bash -c "echo '$CURRENT_USER:$USERPASS' | chpasswd"

# Set password for root user
echo "$SUDOPASS" | sudo -S bash -c "echo 'root:$ROOTPASS' | chpasswd"

# Run system update/upgrade
echo "$SUDOPASS" | sudo -S apt update && echo "$SUDOPASS" | sudo -S apt upgrade -y

echo "Everything is done."
echo "Entering root session..."
su -
