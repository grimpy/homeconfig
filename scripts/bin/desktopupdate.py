#!/usr/bin/env python
import os,sys,re,time

def modFile(filename,rule):
    try:
        f = open(filename,'w+')
        lines = []
        lines.append('# xfce backdrop list\n')
        lines.append(rule)
        f.writelines(lines)
    finally:
        f.close()

months = {1:'jan',2:'feb',3:'mar',4:'apr',5:'may',6:'jun',7:'july',8:'aug',9:'sept',10:'oct',11:'nov',12:'dec'}
timetuple=time.localtime()
baseurl = 'http://happytreefriends.atomfilms.com/goodies/images/desktop_patterns/'
url1 = 'wall_cal_%04d_%s0%d_1280.jpg'%(timetuple[0],months[timetuple[1]],1)
url2 = 'wall_cal_%04d_%s0%d_1280.jpg'%(timetuple[0],months[timetuple[1]],2)
if os.system('wget -nv -c %s -O /home/grimpy/Doc/Media/Pictures/Backgrounds/%s'%(baseurl+url1,url1)) != 0:
    sys.exit(1)
if os.system('wget -nv -c %s -O /home/grimpy/Doc/Media/Pictures/Backgrounds/%s'%(baseurl+url2,url2)) !=0:
    sys.exit(1)
modFile('/home/grimpy/.config/xfce4/desktop/backdrops.list','/home/grimpy/Doc/pictures/backgrounds/%s'%(url1))
modFile('/home/grimpy/.config/xfce4/desktop/backdrops2.list','/home/grimpy/Doc/pictures/backgrounds/%s'%(url2))
os.system('pkill -9 xfdesktop')
os.spawnv(os.P_NOWAIT,'/usr/bin/xfdesktop',('/usr/bin/xfdesktop',))
