#!/bin/sh

mkdir -p /koolshare
export KSROOT=/koolshare

softcenter_install() {
	# install software center files
	if [ -d "/tmp/softcenter" ]; then
		mkdir -p $KSROOT
		mkdir -p $KSROOT/webs/
		mkdir -p $KSROOT/init.d/
		mkdir -p $KSROOT/webs/res/
		mkdir -p $KSROOT/bin/
		cp -rf /tmp/softcenter/webs/* $KSROOT/webs/
		cp -rf /tmp/softcenter/bin/* $KSROOT/bin/
		cp -rf /tmp/softcenter/scripts $KSROOT/
		chmod 755 $KSROOT/bin/*
		chmod 755 $KSROOT/scripts/*

		rm -rf /tmp/softcenter*
		mkdir -p /tmp/upload

		# do something after install completed

	fi
}

softcenter_install
