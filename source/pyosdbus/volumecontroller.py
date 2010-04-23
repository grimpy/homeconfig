#!/usr/bin/env python
import alsaaudio
import sys
import dbus

mixer = 'PCM'
m = alsaaudio.Mixer(mixer)
volume = m.getvolume()[0]
bus = dbus.SessionBus()
proxy = bus.get_object('test.grimpy.pyosdbus', '/test/grimpy/pyosdbus')
showPercentBar = proxy.get_dbus_method('showPercentBar','test.grimpy.pyosdbus')
showText = proxy.get_dbus_method('showText','test.grimpy.pyosdbus')

arg = sys.argv[1]
if arg in '+-':
    volumedelta = int(arg+'5')
    volume+=volumedelta
    if volume > 100:
        volume = 100
    elif volume < 0:
        volume = 0
    m.setvolume(volume)    
    showPercentBar("Volume %s%%" % (volume), volume)
elif arg == '0':
    muted = bool(m.getmute()[0])
    m.setmute(not muted)
    if muted:
        showPercentBar("Volume %s%%" % (volume), volume)
    else:
        showText('Sound Muted')
