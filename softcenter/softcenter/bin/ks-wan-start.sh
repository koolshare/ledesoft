#!/bin/sh

if [ -z $KSROOT ]; then
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
fi

echo start `date` > /tmp/ks_wan_log.txt

# set ks_nat to 1, incase of nat start twice at the same time when booting system or ks-wan-start.sh and ks-nat-start.sh been trigered at the same time.
# because when software start by wan, they start nat when nat is ready.
nvram set ks_nat="1"

#plugin.sh stop
plugin.sh start

# set ks_nat to 0 after system boot finished,
# when system triger only the firewall restart, incase of some software's nat been flushed, set ks_nat to 0,
# the ks-nat-start.sh will start /jffs/koolshare/inin.d/N*.sh to reload software's nat.
nvram set ks_nat="0"

echo finish `date` >> /tmp/ks_wan_log.txt
