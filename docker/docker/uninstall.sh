#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export docker`

rm -rf $docker_basic_disk/docker

confs=`dbus list docker|cut -d "=" -f1`

for conf in $confs
do
	dbus remove $conf
done

sleep 1
rm -rf $KSROOT/scripts/docker*
rm -rf $KSROOT/init.d/S99docker.sh
rm -rf $KSROOT/webs/Module_docker.asp
rm -rf $KSROOT/webs/res/icon-docker.png
rm -rf $KSROOT/webs/res/icon-docker-bg.png
rm -rf $KSROOT/scripts/uninstall_docker.sh

dbus remove softcenter_module_docker_home_url
dbus remove softcenter_module_docker_install
dbus remove softcenter_module_docker_md5
dbus remove softcenter_module_docker_version
dbus remove softcenter_module_docker_name
dbus remove softcenter_module_docker_description
