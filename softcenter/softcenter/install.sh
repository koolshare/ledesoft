#!/bin/sh

mkdir -p /koolshare
export KSROOT=/koolshare

softcenter_install(){
	chmod +x /tmp/softcenter/reload.sh
	start-stop-daemon -S -q -x /tmp/softcenter/reload.sh
}
softcenter_install
