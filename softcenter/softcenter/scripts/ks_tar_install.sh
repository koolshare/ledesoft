#!/bin/sh
export KSROOT=/jffs/koolshare
source $KSROOT/scripts/base.sh

#From dbus to local variable
eval `dbus export soft`
name=`echo "$soft_name"|cut -d "." -f1`

cat /dev/null > /tmp/upload/soft_log.txt
INSTALL_SUFFIX=_install
VER_SUFFIX=_version
NAME_SUFFIX=_name
rm -rf /tmp/upload/soft_log.txt
cd /tmp/upload/
echo $(date): 开启软件离线安装！>> /tmp/upload/soft_log.txt
sleep 1
if [ -f /tmp/upload/$soft_name ];then
	echo $(date): /tmp目录下检测到上传的离线安装包$soft_name >> /tmp/upload/soft_log.txt
	sleep 1
	echo $(date): 尝试解压离线安装包离线安装包 >> /tmp/upload/soft_log.txt
	sleep 1
	tar -zxvf $soft_name -C /tmp >/dev/null 2>&1
	echo $(date): 解压完成！ >> /tmp/upload/soft_log.txt
	sleep 1
	cd /tmp/
	if [ -f /tmp/$name/install.sh ];then
		echo $(date): 找到安装脚本！ >> /tmp/upload/soft_log.txt
		echo $(date): 运行安装脚本... >> /tmp/upload/soft_log.txt
		sleep 1
		chmod +x /tmp/$name/install.sh >/dev/null 2>&1
		sh /tmp/$name/install.sh >/dev/null 2>&1
		dbus set "softcenter_module_$name$NAME_SUFFIX=$name"
		dbus set "softcenter_module_$name$INSTALL_SUFFIX=1"
		dbus set "softcenter_module_$name$VER_SUFFIX=$soft_install_version"
		install_pid=`ps | grep install.sh | grep -v grep | awk '{print $1}'`
		i=120
		until [ ! -n "$install_pid" ]
		do
		    i=$(($i-1))
		    if [ "$i" -lt 1 ];then
		        echo $(date): "Could not load nat rules!"
		        echo $(date): 安装似乎出了点问题，请手动重启路由器后重新尝试... >> /tmp/upload/soft_log.txt
		        echo $(date): 删除相关文件并退出... >> /tmp/upload/soft_log.txt
				sleep 1
		        rm -rf /tmp/$name
		        rm -rf /tmp/upload/$soft_name
		        dbus remove "softcenter_module_$name$INSTALL_SUFFIX"
			echo jobdown >> /tmp/upload/soft_log.txt
		        exit
		    fi
		    sleep 1
		done
		echo $(date): 离线包安装完成！ >> /tmp/upload/soft_log.txt
		sleep 1
		echo $(date): 一点点清理工作... >> /tmp/upload/soft_log.txt
		sleep 1
		rm -rf /tmp/$name
		rm -rf /tmp/upload/$soft_name
		echo $(date): 完成！ >> /tmp/upload/soft_log.txt
		sleep 1
		echo jobdown >> /tmp/upload/soft_log.txt
	else
		echo $(date): 没有找到安装脚本！ >> /tmp/upload/soft_log.txt
		echo $(date): 删除相关文件并退出... >> /tmp/upload/soft_log.txt
		rm -rf /tmp/$name
		rm -rf /tmp/upload/$soft_name
		echo jobdown >> /tmp/upload/soft_log.txt
	fi
else
	echo $(date): 没有找到离线安装包！ >> /tmp/upload/soft_log.txt
	echo $(date): 删除相关文件并退出... >> /tmp/upload/soft_log.txt
	rm -rf /tmp/$name
	rm -rf /tmp/upload/$soft_name
	echo jobdown >> /tmp/upload/soft_log.txt
fi
	echo jobdown >> /tmp/upload/soft_log.txt
	rm -rf /tmp/$name
	rm -rf /tmp/upload/$soft_name
