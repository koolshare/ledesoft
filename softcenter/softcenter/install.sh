#!/bin/sh

mkdir -p /jffs/koolshare
export KSROOT=/jffs/koolshare

softcenter_install() {
	#remove useless files
	if [ -d "$KSROOT/init.d" ]; then
		rm -rf $KSROOT/init.d/S01Skipd.sh >/dev/null 2>&1
		rm -rf $KSROOT/init.d/S10softcenter.sh >/dev/null 2>&1
	fi
	
	# remove database if version below 0.1.5
	if [ -f "$KSROOT/bin/versioncmp" ] && [ -f "$KSROOT/bin/dbus" ] && [ -n `pidof skipd` ];then
		version_installed=`$KSROOT/bin/dbus get softcenter_version`
		version_comp=`$KSROOT/bin/versioncmp "$version_installed" "0.1.5"`
		if [ "$version_comp" == "1" ];then
			killall skipd
			rm -rf /jffs/db
			rm -rf $KSROOT/bin/skipd
		fi
	fi

	# install software center files
	if [ -d "/tmp/softcenter" ]; then
		mkdir -p $KSROOT
		mkdir -p $KSROOT/webs/
		mkdir -p $KSROOT/init.d/
		mkdir -p $KSROOT/res/
		mkdir -p $KSROOT/bin/
		cp -rf /tmp/softcenter/webs/* $KSROOT/webs/
		cp -rf /tmp/softcenter/res/* $KSROOT/res/
		cp -rf /tmp/softcenter/bin/* $KSROOT/bin/
		cp -rf /tmp/softcenter/perp $KSROOT/
		cp -rf /tmp/softcenter/scripts $KSROOT/
		cp -rf /tmp/softcenter/module $KSROOT/
		# copy new tomato.js to dir webs inase of tomato.js upgrade
		[ -f "/rom/softcenter/softcenter.tar.gz" ] && cp -rf /tmp/softcenter/others/tomato.js $KSROOT/webs/

		chmod 755 $KSROOT/bin/*
		chmod 755 $KSROOT/perp/*
		chmod 755 $KSROOT/perp/.boot/*
		chmod 755 $KSROOT/perp/.control/*
		chmod 755 $KSROOT/scripts/*
		chmod 755 $KSROOT/perp/httpdb/*
		chmod 755 $KSROOT/perp/skipd/*

		rm -rf /tmp/softcenter*
		mkdir -p /tmp/upload

		[ ! -L $KSROOT/bin/netstat ] && ln -sf $KSROOT/bin/koolbox $KSROOT/bin/netstat
		[ ! -L $KSROOT/bin/diff ] && ln -sf $KSROOT/bin/koolbox $KSROOT/bin/diff

		[ ! -L $KSROOT/webs/res ] && ln -sf $KSROOT/res $KSROOT/webs/res
		[ ! -f $KSROOT/webs/tomato.js ] && cp /www/tomato.js $KSROOT/webs
		
		if [ ! -f "/rom/softcenter/softcenter.tar.gz" ];then
			# now set the navi portal
			web_dir=`nvram get web_dir`
			case "$web_dir" in
				default)
					webroot="/www"
				;;
				jffs)
					webroot="/jffs/www"
				;;
				opt)
					webroot="/opt/www"
				;;
				tmp)
					webroot="/tmp/www"
				;;
			esac
			softcenter=`cat $webroot/tomato.js | grep soft-center`
			if [ -z "$softcenter" ];then
				nvram set at_nav="{\"SoftCenter\":{\"App List\":\"soft-center.asp\"}}"
			fi
		fi

		# run kscore at last step
		sh /$KSROOT/bin/kscore.sh
	fi
}

softcenter_install
