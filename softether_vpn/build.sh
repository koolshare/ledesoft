#!/bin/sh

MODULE=softether_vpn
VERSION=1.0.2
TITLE=softether_vpn
DESCRIPTION=VPN全家桶
HOME_URL=Module_softether_vpn.asp
#!/bin/sh
# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
echo $DIR
if [ "$MODULE" == "" ]; then
	echo "module not found"
	exit 1
fi

if [ -f "$DIR/$MODULE/$MODULE/install.sh" ]; then
	echo "install script not found"
	exit 2
fi

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
