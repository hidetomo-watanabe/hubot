#!/bin/bash

if [[ ! $(pgrep node) ]]; then
    ./restart_bot.sh
fi
