#!/bin/bash
remoteip=$1
if [ "x$remoteip" != "x" ]; then
	scp $0 $remoteip:/tmp
	ssh $remoteip /tmp/initconfig.sh
	exit 0
fi
pushd ~ > /dev/null
git clone git://github.com/grimpy/homeconfig.git mygit
pushd mygit > /dev/null
sed -i s#git://github.com/#git@github.com:# .git/config
./linkfiles.py
popd > /dev/null
if [ -f /bin/zsh ]; then
    usermod -s /bin/zsh $USER
fi
popd > /dev/null
