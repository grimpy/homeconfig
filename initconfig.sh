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
git clone http://github.com/grimpy/homeconfig.git .
cd homeconfig/.ssh
unzip id_rsa.zip
cd ../..
./linkfiles.py
sed -i s#http://github.com/#git@github.com:# .git/config
