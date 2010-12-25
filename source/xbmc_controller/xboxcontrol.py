#!/usr/bin/env python
import xeventreader
import urllib2
from keys import *
from xcb.xproto import KeyPressEvent, KeyReleaseEvent
import pdb
import string
keyurl = "http://xbox.skynet/xbmcCmds/xbmcHttp?command=SendKey(%s)"
actionurl = "http://xbox.skynet/xbmcCmds/xbmcHttp?command=Action(%s)"

class Xbox(object):
    def __init__(self):
        self.shift = False

    def sendCommand(self, key):
        #pdb.set_trace()
        keyname = xkeys.get(key)
        if keyname:
            if self.shift and keyname in string.ascii_lowercase:
                keyname = keyname.upper()
            xkeyname = keymap.get(keyname)
            if xkeyname:
                xkeycode = xboxkeys.get(xkeyname, xkeyname)
                if xkeycode:
                    urllib2.urlopen(keyurl % (xkeycode))
            actionname = actionmap.get(keyname)
            if actionname:
                xkeycode = xboxkeys.get(actionname)
                if xkeycode:
                    urllib2.urlopen(actionurl % (xkeycode))

if '__main__' == __name__:
    xev = xeventreader.XeventReader()
    x = Xbox()
    while True:
        event = xev.getNextEvent()
        if isinstance(event, KeyPressEvent):
            if event.detail == 76:
                break
            elif event.detail == 50:
                x.shift = True
            x.sendCommand(event.detail)
        elif isinstance(event, KeyReleaseEvent):
            if event.detail == 50:
                x.shift = False
