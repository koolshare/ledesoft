#!/bin/sh

/usr/bin/plugin.sh stop
/usr/bin/plugin.sh start
dbus fire onwanstart
