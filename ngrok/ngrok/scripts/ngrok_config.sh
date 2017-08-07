#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export ngrok_`

onstart() {

killall ngrok || true
txt=$ngrok_txt
en=$ngrok_enable

if [ -z "$txt" ]; then
echo "not config"
else

if [ "$en" == "1" ]; then
touch /tmp/ngrok.log
echo $txt > /tmp/ngrok.json
ngrok -c /tmp/ngrok.json -p /tmp/ngrok.pid -d &
fi
fi
}

case $ACTION in
start)
	onstart
	;;
*)
	onstart
	;;
esac
