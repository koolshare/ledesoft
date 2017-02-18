#!/bin/sh

dbus set testss=okk
echo "test only"

http_response "postend"
