#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export policy_`

mkdir -p $KSROOT/policy
cp -rf /tmp/policy/policy/* $KSROOT/policy/
cp -rf /tmp/policy/scripts/* $KSROOT/scripts/
cp -rf /tmp/policy/webs/* $KSROOT/webs/
cp /tmp/policy/uninstall.sh $KSROOT/scripts/uninstall_policy.sh

chmod +x $KSROOT/scripts/policy_*

dbus set softcenter_module_policy_description=多运营商自动分流
dbus set softcenter_module_policy_install=1
dbus set softcenter_module_policy_name=policy
dbus set softcenter_module_policy_title="策略路由"
dbus set softcenter_module_policy_version=0.1

[ -z "$policy_tarckip" ] && dbus set policy_tarckip="114.114.114.114 119.29.29.29 taobao.com www.baidu.com"
[ -z "$policy_config" ] && dbus set policy_config=1

sleep 1
rm -rf /tmp/policy >/dev/null 2>&1
