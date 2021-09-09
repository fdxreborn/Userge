#!/bin/bash
# Userge Quick Setup
# ======================

# // Export Color
export Color_Red='\033[0;31m'
export Color_Green='\033[0;32m'
export Color_Yellow='\033[0;33m'
export Color_NC='\033[0m'

# // Export Information
export EROR="[${Color_Red} EROR ${Color_NC}]"
export INFO="[${Color_Yellow} INFO ${Color_NC}]"
export OKEY="[${Color_Green} OKEY ${Color_NC}]"

# // Checking Root User
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // OS Requirement
if [[ $( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/"//g') == "20.04" ]]; then
    Supported=yes
else
    clear
    echo -e "${EROR} Sorry Supported Only For Ubuntu 20.04"
    exit 1
fi

# // Accept
echo -e "=================================="
echo -e "  This Script Will Setup Userge"
echo -e "=================================="
echo -e " "
read -p " Press Enter For Start Installation" temp

# // Read Data
clear
read -p "API ID      : " API_ID
read -p "API Hash    : " API_HASH
read -p "MonggoDB    : " MonggoDB
read -p "Channel Log : " Log_ID
read -p "Load Plugin : " Load_Plugin
read -p "Bot Token   : " Token
read -p "Owner ID    : " Owner
read -p "Hu String   : " String

# // Installing Requirement
apt update -y
apt upgrade -y
apt install git -y
apt install python -y
apt install tree -y
apt install wget2 -y
apt install p7zip-full -y
apt install jq -y
apt install ffmpeg -y
apt install wget -y
apt install git -y
apt install python -y
apt install python3 -y
apt install python3-pip -y
apt install python-pip -y

# // Installing Google Chrome
wget -O /root/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i /root/chrome.deb
rm -f /root/chrome.deb

# // Installing Jserge Requirement
cd /root/Userge/
pip install -r requirements.txt

# // Checking If Config.env
if [[ -f /root/Userge/config.env ]]; then
    Skip=true
else
# // Generate Config.env
cat > /root/Userge/config.env << END
#!/bin/bash
#
# Copyright (C) 2020-2021 by UsergeTeam@Github, < https://github.com/UsergeTeam >.
#
# This file is part of < https://github.com/UsergeTeam/Userge > project,
# and is released under the "GNU v3.0 License Agreement".
# Please see < https://github.com/UsergeTeam/Userge/blob/master/LICENSE >
#
# All rights reserved.

# if you fill it correctly, but still having problem
# Remove the quotes foo="bar" to foo=bar 

# ----------- REQUIRED ----------- #


# Get them from https://my.telegram.org/
API_ID="${API_ID}"
API_HASH="${API_HASH}"


# Mongodb url from https://cloud.mongodb.com/
# comment below line if you are going to use docker !
DATABASE_URL="${MonggoDB}"


# Telegram Log Channel ID
LOG_CHANNEL_ID="${Log_ID}"


# one of USERGE MODE
# you can use userge as [ USER or BOT or DUAL ] MODE
# see below for more info


# ----------- OPTIONAL ----------- #


# Set true if your like to use unofficial plugins
LOAD_UNOFFICIAL_PLUGINS=${Load_Plugin}


# assert running single Userge instance to prevent from AUTH_KEY_DUPLICATED error.
ASSERT_SINGLE_INSTANCE=false


# This is best if you wanna add your own plugins
# Set this to fork of https://github.com/UsergeTeam/Custom-Plugins and add your plugins
CUSTOM_PLUGINS_REPO=""

# Userbot Workers Count : Default = cpu_count + 4
WORKERS=""

# Telegram Chat id For Updates of Rss Feed
RSS_CHAT_ID=""

# Googel Drive API Keys from https://console.developers.google.com/
G_DRIVE_CLIENT_ID=""
G_DRIVE_CLIENT_SECRET=""

# Set true if it is TeamDrive
G_DRIVE_IS_TD=false

# Index link for gdrive
G_DRIVE_INDEX_LINK=""

# Set name to your working directory
DOWN_PATH="downloads/"

# Your Languge ( ex: if english => 'en' )
PREFERRED_LANGUAGE="en"

# get API Key from 'https://free.currencyconverterapi.com/'
CURRENCY_API=""

# get API key for OCR module 'http://eepurl.com/bOLOcf'
OCR_SPACE_API_KEY=""

# add default city for weather
WEATHER_DEFCITY=""

# Userge AntiSpam API get it from @UsergeAntiSpamBot in Telegram
USERGE_ANTISPAM_API=""

# SpamWatch API get it from @SpamWatch in Telegram
SPAM_WATCH_API=""

# Weather API get it from 'https://openweathermap.org/'
OPEN_WEATHER_MAP=""

# RemoveBg API Key get it from 'https://www.remove.bg/api'
REMOVE_BG_API_KEY=""

# GDrive Folder ID
G_DRIVE_PARENT_ID=""

# set command prefix
CMD_TRIGGER="."

# set command prefix for SUDO users
SUDO_TRIGGER="!"

# set this to your USERGE fork on GitHub
UPSTREAM_REPO=""

# single character for finished progress
FINISHED_PROGRESS_STR='█'

# single character for unfinished progress
UNFINISHED_PROGRESS_STR='░'

# custom name for your sticker pack
CUSTOM_PACK_NAME=""

# custom audio max duration for voice chat plugin
MAX_DURATION=900

# set your own custom media for .alive or
# disable it by putting value 'nothing'
# accepted formats:
#     a link to message: https://t.me/theuserge/8
#     chat and message id separated by |: -1005545442|84565
ALIVE_MEDIA=""

# ----------- USERGE MODES ----------- #

# >>> USER MODE <<< #
# use userge as user
# get this using [ '@genStr_Bot' or `bash genStr` ]
HU_STRING_SESSION="${String}"

# >>> BOT MODE <<< #
# use userge as bot
# get this from https://t.me/botfather if you like to use userge as a bot
# And your user id 
BOT_TOKEN="${Token}"
OWNER_ID="${Owner}" 

# >>> DUAL MODE <<< #
# use userge as both user and bot
# fill all USER MODE and BOT MODE vars
END
fi

# // Adding Service For AutoStart Bot
cat > /etc/systemd/system/userge.service << END
[Unit]
Description=Userge Telegram Userbot Service
Documentation=https://github.com/UsergeTeam/Userge https://github.com/wildyproject/Userge

[Service]
User=root
NoNewPrivileges=true
WorkingDirectory=/root/Userge/
ExecStart=/bin/bash /root/Userge/run
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
END

# // Menu Start / Stop
echo '#!/bin/bash

input=$1

if [[ $input == "start" ]]; then
    systemctl enable userge
    systemctl stop userge
    systemctl start userge
    echo "Userge Started"
elif [[ $input == "stop" ]]; then
    systemctl disable userge
    systemctl stop userge
    echo "Userge Stopped"
elif [[ $input == "restart" ]]; then
    systemctl restart userge
    echo "Userge Restarted"
else
    clear
    echo "Avaiable Command !"
    echo "==================================="
    echo "userge start   : Startinig Userge"
    echo "userge stop    : Stoping Userge"
    echo "userge restart : Restarting Userge"
    echo "==================================="
fi' > /usr/bin/userge 
chmod +x /usr/bin/userge
userge
