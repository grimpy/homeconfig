#!/bin/bash
remoteip=$1
if [ "x$remoteip" != "x" ]; then
	scp $0 $remoteip:/tmp
	ssh $remoteip /tmp/initconfig.sh
	exit 0
fi
cd
mkdir mygit
cd mygit
git clone git://github.com/grimpy/homeconfig.git .
cd homeconfig/.ssh
unzip id_rsa.zip && sed -i s#git://github.com/#git@github.com:# ../../.git/config
cd ../..
./linkfiles.py
if [ -f /bin/zsh ]; then
    usermod -s /bin/zsh $USER
fi
