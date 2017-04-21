#!/bin/bash

source ~/.nvm/nvm.sh
export HUBOT_SLACK_TOKEN=`cat data/slack_token`
pkill node
./bin/hubot --adapter slack >> log 2>&1 &
