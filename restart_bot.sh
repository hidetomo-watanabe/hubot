#!/bin/sh

source ~/.nvm/nvm.sh
export HUBOT_SLACK_TOKEN=`cat data/slack_token`
# tmp
pkill node
./bin/hubot --adapter slack &
