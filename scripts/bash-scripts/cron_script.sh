#!/bin/bash
# Start the data extraction process

#Create a log file to track
logfile_path=$HOME/Documents/cde_ass
script_path=$HOME/Documents/cde_ass/scripts/bash-scripts

#Script is to run at midnight daily
Current_Time=$(date '+%Y-%m-%d %H:%M:%S')
echo "Script started at $Current_Time" >> "$logfile_path/cronlog.txt"

#Schedule cron job for midnight daily
cron_task="* * * * * $script_path/etl-process.sh"

# Step 2: Check if the cron job already exists
cronjob="* * * * * /path/to/script.sh"

#Check if cronjob exists and append if it doesn't exist.
(crontab -l | grep -q "$cronjob") || (crontab -l; echo "$cronjob") | crontab -
