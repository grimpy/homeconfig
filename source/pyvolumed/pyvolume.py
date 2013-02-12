#!/usr/bin/env python
import alsaaudio
import keybinder
import pynotify
import gtk

def generatePixBuf(percentage, mute=False):
    HEIGHT= 10
    WIDTH = 100
    fillcolor = [0, 125, 255] if not mute else [255,0,0]
    emptycolor = [0,0,0]
    pixbuf = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, False, 8, WIDTH, HEIGHT)
    data = pixbuf.get_pixels_array()
    for x in xrange(WIDTH):
        color = fillcolor if x < percentage else emptycolor
        for y in xrange(HEIGHT):
            data[y][x] = color
    return pixbuf


class Mixer(object):
    def __init__(self, mixer):
        self._mixer = mixer
        self._maxvolume = 100

    @property
    def rawmixer(self):
        return alsaaudio.Mixer(self._mixer)

    def get_volume(self):
        return self.rawmixer.getvolume()[0]

    def set_volume(self, volume):
        mix = self.rawmixer
        vol = mix.getvolume()[0] + volume
        if vol > self._maxvolume:
            vol = self._maxvolume
        elif vol < 0:
            vol = 0
        mix.setvolume(vol)
        return vol

    def get_mute(self):
        return self.rawmixer.getmute()[0]


    def set_mute(self, mute):
        return self.rawmixer.setmute(mute)


MIXER = 'Master'
mixer = Mixer(MIXER)

nt = None

def getNotification():
    global nt
    pynotify.uninit()
    pynotify.init("volumecontroller")
    nt = pynotify.Notification(" ")
    nt.set_hint_int32("value",50)
    nt.set_hint_string("x-canonical-private-synchronous","")

getNotification()

def getNotificationIcon(vol):
    if mixer.get_mute():
        return "audio-volume-muted"
    if vol == 0:
        return "audio-volume-off"
    elif vol < 34:
        return "audio-volume-low"
    elif vol < 67:
        return "audio-volume-medium"
    else:
        return "audio-volume-high"

def createbar(percentage):
    factor = 0.75
    stat1 = int(percentage*factor)
    stat2 = int((100*factor)) - stat1
    return "[%s%s]" % ("|" * stat1, "-"* stat2)

def notifyDelta(delta, retry=3):
    try:
        vol = mixer.set_volume(delta)
        nt.set_hint_int32("value",vol)
        muted = mixer.get_mute()
        nt.set_icon_from_pixbuf(generatePixBuf(vol, muted))
        nt.show()
    except Exception, e:
        print e
        retry -=1
        if retry > 0:
            getNotification()
            notifyDelta(delta, retry)


def toggleMute(_):
    value = mixer.get_mute()
    mixer.set_mute(not value)
    notifyDelta(0)
#format = "llHHi"

def main():
    keybinder.bind('<Super>Up', notifyDelta, 5)
    keybinder.bind('XF86AudioRaiseVolume', notifyDelta, 5)
    keybinder.bind('XF86AudioLowerVolume', notifyDelta, -5)
    keybinder.bind('<Super>0', toggleMute, None)
    keybinder.bind('XF86AudioMute', toggleMute, None)
    gtk.mainloop()


if '__main__' == __name__:
    main()
