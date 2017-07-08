#!/bin/sh
#2017/04/21 by kenney
#version 0.1

export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

xunleiPath=$KSROOT/xunlei
if [ ! -z "$xunleiPath" ];then
	#sleep 10
	$xunleiPath/portal -s &
	sleep 1
	$xunleiPath/portal >/tmp/xunlei.log&
fi
