#!/bin/bash

#Credits to https://github.com/oliranks/openHAB3-full_backup_and_restore

TIMESTAMP="`date +%Y%m%d_%H%M%S`";
BACKUPDIR="/data/backups/";
BACKUPNAME="openhab-full-backup";

echo -e "\e[96m#############################\e[0m"
echo -e "\e[96m##### \e[31mStopping services \e[96m#####\e[0m"
echo -e "\e[96m#############################\e[0m"
echo -e "Stopping openhab service..."
sudo systemctl stop openhab.service
echo -e "openhab service \e[31mstopped\e[0m."
echo -e ""

echo -e "\e[96m######################################\e[0m"
echo -e "\e[96m##### \e[31mFolder setup \e[96m#####\e[0m"
echo -e "\e[96m######################################\e[0m"
echo -e "Creating openhab backup directory:";
sudo mkdir -v "$BACKUPDIR$BACKUPNAME/openhab";
echo -e "Creating influxdb backup directory:";
sudo mkdir -v "$BACKUPDIR$BACKUPNAME/influxdb";
echo -e ""

echo -e "\e[96m###########################\e[0m"
echo -e "\e[96m##### \e[31mopenHAB3 Backup \e[96m#####\e[0m"
echo -e "\e[96m###########################\e[0m"
echo -e "Creating openHAB3 backup..."
sudo openhab-cli backup "$BACKUPDIR$BACKUPNAME/openhab/openhab-backup.zip"

echo -e "\e[96m###########################\e[0m"
echo -e "\e[96m##### \e[31mInfluxdb Backup \e[96m#####\e[0m"
echo -e "\e[96m###########################\e[0m"
echo -e "Copying influxdb config file..."
sudo cp -arv "/data/docker/influxdb/conf/influxdb.conf" "$BACKUPDIR$BACKUPNAME/influxdb/influxdb.conf"
echo -e "Exporting influxdb database..."
sudo rm -Rf /var/lib/docker/volumes/influxdb_backups/_data/db
sudo docker exec InfluxDB influxd backup -database openhab -portable "/backups/db/"
sudo mv /var/lib/docker/volumes/influxdb_backups/_data/db/ $BACKUPDIR$BACKUPNAME/influxdb/
echo -e ""

echo -e "\e[96m###############################\e[0m"
echo -e "\e[96m##### \e[31mRestarting services \e[96m#####\e[0m"
echo -e "\e[96m###############################\e[0m"
echo -e "Starting openhab service..."
sudo systemctl start openhab.service
echo -e "openhab service \e[32mstarted\e[0m."
echo -e ""

echo -e "\e[96m##############################\e[0m"
echo -e "\e[96m##### \e[31mCompressing backup \e[96m#####\e[0m"
echo -e "\e[96m##############################\e[0m"
cd $BACKUPDIR
sudo tar cfvz $BACKUPDIR$BACKUPNAME-$TIMESTAMP.tar.gz $BACKUPNAME/
echo -e ""

echo -e "Backup finished!"
echo -e ""

echo -e "Total backup folder size:"
sudo du -sh -- $BACKUPDIR$BACKUPNAME/*
echo -e ""

echo -e "Compressed backup file size:"
sudo du -sh -- $BACKUPDIR$BACKUPNAME-$TIMESTAMP.tar.gz
echo -e ""

echo -e "\e[96m#######################\e[0m";
echo -e "\e[96m##### \e[31mCleaning up \e[96m#####\e[0m";
echo -e "\e[96m#######################\e[0m";
sudo rm -rf $BACKUPDIR$BACKUPNAME/openhab
sudo rm -rf $BACKUPDIR$BACKUPNAME/influxdb
echo -e "Temporary directory deleted.";
echo -e "";

echo -e "Backup created \e[32msucessfully\e[0m! -> $BACKUPDIR$BACKUPNAME-$TIMESTAMP.tar.gz"
