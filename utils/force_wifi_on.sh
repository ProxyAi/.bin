#!/bin/bash

# Author: admin@xoren.io
# Script: force_wifi_on.sh
# Link https://github.com/xorenio
# Description: Script to disable power saving for wifi adapter.

sudo iw dev wlp1s0 set power_save off
