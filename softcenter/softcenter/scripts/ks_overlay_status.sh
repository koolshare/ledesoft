#!/bin/sh
source /koolshare/scripts/base.sh

TOTAL=$(df -h|grep overlayfs|awk '{print $2}'|sed 's/M//g')
USED=$(df -h|grep overlayfs|awk '{print $3}'|sed 's/M//g')
http_response "$TOTAL>$USED"