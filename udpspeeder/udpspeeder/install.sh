#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export udpspeeder_`

mkdir -p $KSROOT/init.d
mkdir -p /tmp/upload

# stop udpspeeder if enabled
[ -n "`pidof UDPspeeder`" ] && sh $KSROOT/scripts/udpspeeder_config.sh stop

cp -r /tmp/udpspeeder/* $KSROOT/
chmod +x $KSROOT/bin/UDPspeeder
chmod +x $KSROOT/scripts/udpspeeder_*
chmod +x $KSROOT/init.d/S99udpspeeder.sh
rm -rf $KSROOT/install.sh

# add icon into softerware center
dbus set softcenter_module_udpspeeder_install=1
dbus set softcenter_module_udpspeeder_name=udpspeeder
dbus set softcenter_module_udpspeeder_title=UDPspeeder
dbus set softcenter_module_udpspeeder_description="UDP双边加速工具"
dbus set softcenter_module_udpspeeder_version=1.0.0

# remove old files if exist
find /etc/rc.d/ -name *udpspeeder.sh* | xargs rm -rf

# now create start up file
ln -sf /koolshare/init.d/S99udpspeeder.sh /etc/rc.d/S99udpspeeder.sh

# apply udpspeeder
sh $KSROOT/scripts/udpspeeder_config.sh start

return 0