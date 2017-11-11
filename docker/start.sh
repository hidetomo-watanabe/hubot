#!/bin/bash

sudo /etc/init.d/cron start
cd /home/hidetomo/hubot
sh ./restart_bot.sh

while true; do
  sleep 10
done
