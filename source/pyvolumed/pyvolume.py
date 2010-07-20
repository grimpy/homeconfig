#!/usr/bin/env python
import alsaaudio
import sys
import xcb, xcb.xproto
import pynotify
import pdb
XCB_GRAB_MODE_ASYNC = 1
UP_ARROW = 111
DOWN_ARROW = 116
ZERO_KEY = 19

METAMOD = xcb.xproto.ModMask._4
NUMLOCK = xcb.xproto.ModMask._2
CAPSLOCK = xcb.xproto.ModMask.Lock


MIXER = 'Master'
mixer = alsaaudio.Mixer(MIXER)
maxvolumescale = 100

pynotify.init("volumecontroller")
nt = pynotify.Notification("Volume muted")
nt.set_hint_int32("value",50)
nt.set_hint_string("x-canonical-private-synchronous","")


def getVolume():
    return mixer.getvolume()[0]

def newVolume(delta):
    vol = getVolume() + delta
    if vol > maxvolumescale:
        vol = maxvolumescale
    elif vol < 0:
        vol = 0
    mixer.setvolume(vol)
    return vol

def getNotificationIcon(vol):
    if mixer.getmute()[0]:
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

def notifyDelta(delta):
    vol = newVolume(delta)
    nt.set_hint_int32("value",vol)
    muted = "" if not mixer.getmute()[0] else "Muted"
    nt.update("%s Volume %s %d%%" % (MIXER, muted, vol), createbar(vol), getNotificationIcon(vol))
    nt.show()

def toggleMute():
    value = mixer.getmute()[0]
    mixer.setmute(not value)
    notifyDelta(0)
#format = "llHHi"
def main():
    con = xcb.connect()
    setup = con.get_setup()
    rootwin = setup.roots[0].root
    keys = (UP_ARROW, DOWN_ARROW, ZERO_KEY)
    mods = (NUMLOCK, CAPSLOCK, 0)
    for key in keys:
        for mod in mods:
            mod = mod | METAMOD
            cookie = con.core.GrabKeyChecked(True, rootwin, mod, key, XCB_GRAB_MODE_ASYNC, XCB_GRAB_MODE_ASYNC)
            if cookie.check():
                raise Exception("Could not connect to X")

    while True:
        event = con.wait_for_event()
        if isinstance(event, xcb.xproto.KeyReleaseEvent):
            if event.detail == UP_ARROW:
                notifyDelta(+5)
            elif event.detail == DOWN_ARROW:
                notifyDelta(-5)
            elif event.detail == ZERO_KEY:
                toggleMute()


if '__main__' == __name__:
    main()
