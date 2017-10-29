#!/bin/bash

if [ ! $(pgrep node) ]; then
    sh ./restart_bot.sh
fi
