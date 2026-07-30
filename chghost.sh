#!/bin/bash

# Set Colors
NC="0m"
GREEN="0;32m"
YELLOW="0;33m"

# Set Default Options
dryRun=1
chgHost=0
backupDir="/rmmbackups/chghost-$1"

# Set Default Files to Modify
chgFile[0]="/var/www/rmm/dist/env-config.js"
chgFile[1]="/etc/nginx/sites-available/rmm.conf"
chgFile[2]="/etc/nginx/sites-available/frontend.conf"
chgFile[3]="/etc/nginx/sites-available/meshcentral.conf"
chgFile[4]="/meshcentral/meshcentral-data/config.json"
chgFile[5]="/rmm/api/tacticalrmm/tacticalrmm/local_settings.py"


# Display Proposed Edits
echo -e "Changing from \e[$YELLOW[ $1 ] \e[0mto \e[$GREEN[ $2 ]\e[$NC\n"


# Get User Settings
read -n 1 -r -p "Do you wish to continue? [Y/n] " ynCont
echo -e "\n"
[ "${ynCont,,}" == "y" ] || exit 0

read -n 1 -r -p "Change Host Files? [Y/n] " ynHost
echo -e "\n"
[ "${ynHost,,}" == "y" ] && chgHost=1

read -n 1 -r -p "Dry Run? [Y/n] " ynDry
echo -e "\n"
[ "${ynDry,,}" == "n" ] && dryRun=0


# Apply Settings
if [[ $chgHost -eq 1 ]]; then
    chgFile[6]="/etc/hosts"
    chgFile[7]="/etc/hostname"
fi

if [[ $dryRun -eq 0 ]]; then
    mkdir -p $backupDir
    cp -rp /meshcentral/meshcentral-data/signedagents $backupDir
    rm -r /meshcentral/meshcentral-data/signedagents/*
fi


# Process Files
for i in "${chgFile[@]}"
do
    printf '\33[H\33[2J'
    echo -e "Changing File: \e[$YELLOW$i\e[$NC"
    echo -e "\n"
    sed "s/$1/$2/g" $i | diff --color $i -
    echo -e "\n"

    if [[ $dryRun -eq 0 ]]; then
        cp -p $i $backupDir/
        sed -i "s/$1/$2/g" $i
    fi

    read -n 1 -r -s -p $'Press enter to continue...\n'
    echo -e "\n"
done


# Restart Services
[ $dryRun -eq 0 ] || exit 0
printf '\33[H\33[2J'
for i in meshcentral nats nats-api rmm nginx
do
    cp -rp /etc/nginx/sites-available/* /etc/nginx/sites-enabled/
    systemctl restart $i
    systemctl status $i
    echo -e "\n"
done
