#!/bin/bash

# Ask for password for current user
echo -n "Enter a new password for the current user ($(whoami)): "
read -s USERPASS
echo

# Ask for password for root user
echo -n "Enter a new password for the root user: "
read -s ROOTPASS
echo

# Get current username
CURRENT_USER=$(whoami)

# Set password for current user
echo "$CURRENT_USER:$USERPASS" | sudo chpasswd

# Set password for root user
echo "$ROOTPASS" | sudo chpasswd

# Update and upgrade the system using the current user's password
echo "$USERPASS" | sudo -S apt update && echo "$USERPASS" | sudo -S apt upgrade -y

echo "Everything is done."
echo "Entering root session..."
su -
