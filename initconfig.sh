#!/bin/bash
cd
mkdir mygit
cd mygit
git clone http://github.com/grimpy/homeconfig.git .
./linkfiles.py
sed -i s#http://github.com/#git@github.com:# .git/config
