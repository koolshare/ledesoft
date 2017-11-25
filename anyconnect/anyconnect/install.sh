#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export anyconnect_`

cd /tmp
cp -rf /tmp/anyconnect/scripts/* $KSROOT/scripts/
cp -rf /tmp/anyconnect/webs/* $KSROOT/webs/
cp /tmp/anyconnect/uninstall.sh $KSROOT/scripts/uninstall_anyconnect.sh

chmod +x $KSROOT/scripts/anyconnect_*

dbus set softcenter_module_anyconnect_description="与你的网络无缝并行"
dbus set softcenter_module_anyconnect_install=1
dbus set softcenter_module_anyconnect_name=anyconnect
dbus set softcenter_module_anyconnect_title="AnyConnect Server"
dbus set softcenter_module_anyconnect_version=0.1

check_version(){
	local fwlocal checkversion
	fwlocal=`cat /etc/openwrt_release|grep DISTRIB_RELEASE|cut -d "'" -f 2|cut -d "V" -f 2`
	checkversion=`versioncmp $fwlocal 2.9`
	[ "$checkversion" == "1" ] && {
		rm -rf /etc/ocserv/*.pem
		rm -rf /etc/ocserv/pki
	}
}

check_version
sleep 1
[ -f $KSROOT/webs/files/ca.crt ] && rm -rf $KSROOT/webs/files/ca.crt
[ -f $KSROOT/webs/files/anyconnect.p12 ] && rm -rf $KSROOT/webs/files/anyconnect.p12

rm -rf /tmp/anyconnect* >/dev/null 2>&1
