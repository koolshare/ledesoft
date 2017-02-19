#!/bin/sh

if [ -z $KSROOT ]; then
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh
fi

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		cp -rf /tmp/softcenter/webs/* $KSROOT/webs/
		cp -rf /tmp/softcenter/init.d/* $KSROOT/init.d/
		cp -rf /tmp/softcenter/res/* $KSROOT/res/
		cp -rf /tmp/softcenter/bin/* $KSROOT/bin/
		cp -rf /tmp/softcenter/perp $KSROOT/
		cp -rf /tmp/softcenter/scripts $KSROOT/
		chmod 755 $KSROOT/bin/*
		chmod 755 $KSROOT/init.d/*
		chmod 755 $KSROOT/perp/*
		chmod 755 $KSROOT/perp/.boot/*
		chmod 755 $KSROOT/perp/.control/*
		chmod 755 $KSROOT/scripts/*
		rm -rf /tmp/softcenter
		rm -rf $KSROOT/init.d/S10Softcenter.sh
		if [ ! -L "$KSROOT/init.d/S10Softcenter.sh" ]; then
			ln -sf $KSROOT/scripts/ks_app_install.sh $KSROOT/init.d/S10softcenter.sh
		fi
		rm -rf $KSROOT/res/icon-koolsocks.png
		dbus remove softcenter_module_koolsocks_install
		dbus remove softcenter_module_koolsocks_version
		if [ -f "$KSROOT/ss/ssconfig.sh" ]; then
			dbus set softcenter_module_shadowsocks_install=4
		fi
	fi
}

softcenter_install
