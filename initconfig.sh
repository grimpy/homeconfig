#!/bin/bash
cd
mkdir mygit
cd mygit
git clone http://github.com/grimpy/homeconfig.git .
cd homeconfig/.ssh
unzip id_rsa.zip
cd ../..
./linkfiles.py
sed -i s#http://github.com/#git@github.com:# .git/config
