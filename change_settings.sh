#!/bin/bash

clear
echo ""
echo "****************************"
echo "*** CHANGE CONFIGURATION ***"
echo "****************************"
echo ""
echo "Change options or leave blank"
echo ""
echo ""

_homepath="/home/xilinx/azure-iot-hub-pynq/"

online_dashboard="azure-iot-dashboard"
offline_dashboard="azure-iot-dashboard-mini"
esp32="esp32-python-http-server"
flask="microserver-flask"
iotmessages="azureiot-messages"
tgbot="azure-iot-telegram-bot"

frontend_dashboard_environments_json="$_homepath/$online_dashboard/src/environments/environment.ts"
frontend_dashboard_azure_json="$_homepath/$online_dashboard/config.json"
azure_messages_json="$_homepath/$iotmessages/azure_config.json"


IFS=', ' read -r -a ips_array <<< "$(hostname -I)"
read -p "Choose actual IP [ ${ips_array[0]} / ${ips_array[1]} / ${ips_array[2]}]: " chosen_ip
echo "You set $chosen_ip"

read -p "Write board name: " chosen_board_name
echo "You set $chosen_board_name"

read -p "Write event connection string: " chosen_event_connection_string
echo "You set $chosen_event_connection_string"

read -p "Write cloud to device connection string: " chosen_cloud_to_device_connection_string
echo "You set $chosen_cloud_to_device_connection_string"

read -p "Write device to cloud connection string: " chosen_device_to_cloud_connection_string
echo "You set $chosen_device_to_cloud_connection_string"

read -p "Write device id: " chosen_device_id
echo "You set $chosen_device_id"


JSON_STRING="
export const environment = {
  production: false,
  local: false,
  server: 'http://$chosen_ip:3000',
  deviceName: '$chosen_board_name'
};
"

#echo $JSON_STRING
echo $JSON_STRING > $frontend_dashboard_environments_json
echo "changed in $frontend_dashboard_environments_json"

#Endpoint=sb://ihsuprodamres019dednamespace.servicebus.windows.net/;SharedAccessKeyName=iothubowner;SharedAccessKey=aMAtWHIITXjgS0DGIOeFG38wFOMshbLUprSKzaqgBEQ=;EntityPath=iothub-ehub-z7010-3876357-5826ddaa93
#HostName=Z7010.azure-devices.net;SharedAccessKeyName=service;SharedAccessKey=fTw2DV4CniY+M+d0iuSmn3OkXZfZDKAH77CyQic2j68=
#Z7010-board1

JSON_STRING="
{
  \"eventConnectionString\": \"$chosen_event_connection_string\",
  \"eventEndpoint\": \"\$Default\",
  \"cloudToDeviceConnectionString\": \"$chosen_cloud_to_device_connection_string\",
  \"deviceId\": \"$chosen_device_id\"
}"

#echo $JSON_STRING
echo $JSON_STRING > $frontend_dashboard_azure_json
echo "changed in $frontend_dashboard_azure_json"

#HostName=Z7010.azure-devices.net;DeviceId=Z7010-board1;SharedAccessKey=tSZ5eYqdBjSGMnhcPQsJqJaPxyuQ1TCJYvAPveN3iVg=

JSON_STRING="
{
	\"connection_string\": \"$chosen_device_to_cloud_connection_string\"
}
"

#echo $JSON_STRING
echo $JSON_STRING > $frontend_dashboard_azure_json
echo "changed in $azure_messages_json"

echo "Regenerate sources..."

cd $online_dashboard
npm run build
cd $_homepath
sudo pm2 restart all
sudo pm2 reset all

echo "Done!"
echo ""
echo ""
echo ""

