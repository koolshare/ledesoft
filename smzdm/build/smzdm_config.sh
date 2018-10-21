#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export smzdm_`

gen_user_config() {
	cat /dev/null > $KSROOT/smzdm/account.ini
	local user_nu user_name user_passwd
	user_nu=`dbus list smzdm_user_name_|wc -l`
	for i in `seq $user_nu`
	do
		user_name=`dbus get smzdm_user_name_$i`
		user_passwd=`dbus get smzdm_user_passwd_$i`
		echo "[user$i]" >> $KSROOT/smzdm/account.ini
		echo "username=$user_name" >> $KSROOT/smzdm/account.ini
		echo "password=$user_passwd" >> $KSROOT/smzdm/account.ini
	done
}

random()
{
  min=$1
  max=$(($2-$min+1))
  num=$(date +%s%N)
  echo $(($num%$max+$min))
}
 
set_cru(){
	if [ "$smzdm_enable" == "1" ]; then
    local out=$(random 1 180);
		sed -i '/smzdmcheckin/d' /etc/crontabs/root >/dev/null 2>&1
		echo "0 $smzdm_hour * * * sleep $out && $KSROOT/scripts/smzdm_config.sh smzdmcheckin" >> /etc/crontabs/root
	else
		sed -i '/smzdmcheckin/d' /etc/crontabs/root >/dev/null 2>&1
	fi
}

creat_start_up(){
  [ ! -L "/etc/rc.d/S99smzdm.sh" ] && ln -sf /koolshare/init.d/S99smzdm.sh /etc/rc.d/S99smzdm.sh
}

del_start_up(){
	rm -rf /etc/rc.d/S99smzdm.sh >/dev/null 2>&1
}

start_smzdm(){
	gen_user_config
	/usr/bin/python $KSROOT/smzdm/smzdm.py start &
	set_cru
}

stop_smzdm(){
  set_cru
  del_start_up
}

case "$1" in
  smzdmcheckin)
    start_smzdm
  ;;
  *)
    if [ "$smzdm_enable" == "1" ];then
      start_smzdm
      http_response "$1"
    else
      stop_smzdm
      http_response "$1"
    fi
esac
