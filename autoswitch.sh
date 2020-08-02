#!/bin/bash

SERVER_HOST=/home/vyce/repos/v2ray-autoswitch/servers
CONFIG_PATH=/home/vyce/Documents/v2ray.json

echo `date` "autoswitch start" >> /tmp/v2ray-autoswitch.log

min_rtt=1000000
while read server; do
  # echo $server
  ping -c 1 -W 1 $server > /dev/null 
  if [[ "$?" -eq "0" ]]; then
    avg_rtt=`ping -c 4 ${server} | tail -1| awk '{print $4}' | cut -d '/' -f 2`
    avg_rtt=${avg_rtt%.*}
    echo "server" $server "avg_rtt" $avg_rtt  >> /tmp/v2ray-autoswitch.log
    if [[ $avg_rtt -lt $min_rtt ]]; then
      min_rtt=$avg_rtt
      best_server=$server
    fi
  fi
done < $SERVER_HOST

echo "best_server" $best_server >> /tmp/v2ray-autoswitch.log
if [[ -z "$best_server" ]]; then 
  echo "None is available. Aborted."
  exit
fi

sed -i -e "s/\"address\": .*/\"address\": \"${best_server}\",/g" $CONFIG_PATH
systemctl restart v2ray.service
systemctl status v2ray.service

echo `date` "autoswitch done" >> /tmp/v2ray-autoswitch.log
