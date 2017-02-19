#!/bin/sh

for line in $(dbus list __event__onwanstart_|cut -d"=" -f2)
do
	sh $line
done

