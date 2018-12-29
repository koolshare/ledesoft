#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export docker_`

mkdir -p $KSROOT/init.d
cp -rf /tmp/docker/init.d/* $KSROOT/init.d/
cp -rf /tmp/docker/scripts/* $KSROOT/scripts/
cp -rf /tmp/docker/webs/* $KSROOT/webs/
cp /tmp/docker/uninstall.sh $KSROOT/scripts/uninstall_docker.sh

chmod +x $KSROOT/scripts/docker_*
chmod +x $KSROOT/scripts/uninstall_docker.sh

dbus set softcenter_module_docker_description=轻量虚拟化应用程序
dbus set softcenter_module_docker_install=1
dbus set softcenter_module_docker_name=docker
dbus set softcenter_module_docker_title="Docker"
dbus set softcenter_module_docker_version=0.1

sleep 1
rm -rf /tmp/docker >/dev/null 2>&1
