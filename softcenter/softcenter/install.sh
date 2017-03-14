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
		chmod 755 $KSROOT/perp/httpdb/*
		chmod 755 $KSROOT/perp/skipd/*

		rm -rf /tmp/softcenter*
		mkdir /tmp/upload

		[ ! -L "$KSROOT/init.d/S10softcenter.sh" ] && ln -sf $KSROOT/scripts/ks_app_install.sh $KSROOT/init.d/S10softcenter.sh
		[ ! -L $KSROOT/webs/res ] && ln -sf $KSROOT/res $KSROOT/webs/res
	fi
}

softcenter_install
