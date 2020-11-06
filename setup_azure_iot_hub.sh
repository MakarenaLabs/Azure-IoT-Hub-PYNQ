#!/bin/bash

BITSTREAM=""

_homepath="/home/xilinx/Azure-IoT-Hub-PYNQ/"

while [ -z $BITSTREAM ]
do
    echo -en "Bitstream [microzed/ultra96]: "
    read BITSTREAM
    if [ -z $BITSTREAM ];then
        echo "[ERR]: Bitstream cannot be empty!"
    fi
done

if [[ $BITSTREAM != "microzed" ]] && [[ $BITSTREAM != "ultra96" ]];then
    echo "[ERR] Wrong bitstream. Exit now."
    exit
fi

online_dashboard="azure-iot-dashboard"
offline_dashboard="azure-iot-dashboard-mini"
esp32="esp32-python-http-server"
flask="microserver-flask"
iotmessages="azureiot-messages"
tgbot="azure-iot-telegram-bot"

ESP32_OFFLINE_SERVER="ESP32_OFFLINE_SERVER"
FE_SERVER="FE_SERVER"
FLASK_SERVER="FLASK_SERVER"
SEND_MESSAGES="SEND_MESSAGES"
RECEIVE_MESSAGES="RECEIVE_MESSAGES"
AZURE_IOT_TGBOT="AZURE_IOT_TGBOT"

sudo apt-get install nginx jq curl build-essential
sudo cp nginx/default /etc/nginx/sites-available/
sudo service nginx reload

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install nodejs
sudo npm install -g npm@6.14.8
sudo npm install pm2 -g

cd ${_homepath}

# Setting up all submodules

# Online dashboard
cd ${_homepath}
cd ${online_dashboard}
npm i
npm run build
sudo pm2 start server.js --name ${FE_SERVER}

# Offline dashboard
# Nothing to do

# ESP32 Server
cd ${_homepath}
cd ${esp32}
git checkout master
sudo pip3 install -r requirements.txt
sudo pm2 start routing_server.py --name ${ESP32_OFFLINE_SERVER} --interpreter python3 -- -r ${_homepath}/${offline_dashboard}

# Send & receive messages
cd ${_homepath}
cd ${iotmessages}
sudo pip3 install -r requirements.txt
sudo pm2 start send_messages.py --name ${SEND_MESSAGES} --interpreter python3
sudo pm2 start receive_messages.py --name ${RECEIVE_MESSAGES} --interpreter python3

# Microserver flask
cd ${_homepath}
cd ${flask}
git checkout master
sudo pip3 install -r requirements.txt

_uart=""
_gpio=""

if [[ $BITSTREAM == "microzed" ]];then
    _uart="0x42c00000"
    _gpio="0x41200000"
elif [[ $BITSTREAM == "ultra96" ]];then
    _uart="0x00a0000000"
    _gpio="0x00a0010000"
fi

JSON_STRING=$( jq -n \
                  --arg bn "bitstreams/$BITSTREAM.bit" \
                  --arg uart "$_uart" \
                  --arg gpio "$_gpio" \
                  '{bitstream: $bn, 
                    addresses:{
                        uart: $_uart,
                        gpio: $_gpio
                    }}' )

echo $JSON_STRING > config.json

sudo pm2 start run.sh --name ${FLASK_SERVER}

# Telegram Bot
cd ${_homepath}
cd ${tgbot}
git checkout master
npm i
./first_config.sh
sudo pm2 start server.js --name ${AZURE_IOT_TGBOT}

# At the end of script, pm2 list to check daemons
cd ${_homepath}

sudo pm2 startup
sudo pm2 save

sudo pm2 list
