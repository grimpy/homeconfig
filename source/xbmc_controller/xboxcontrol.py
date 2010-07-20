#!/usr/bin/env python
import xeventreader
import urllib2
from keys import *
from xcb.xproto import KeyPressEvent
import pdb
keyurl = "http://1.1.0.3/xbmcCmds/xbmcHttp?command=SendKey(%s)"
actionurl = "http://1.1.0.3/xbmcCmds/xbmcHttp?command=Action(%s)"
def sendCommand(key):
    keyname = xkeys.get(key)
    if keyname:
        xkeyname = keymap.get(keyname)
        if xkeyname:
            xkeycode = xboxkeys.get(xkeyname)
            if xkeycode:
                urllib2.urlopen(keyurl % (xkeycode))
        actionname = actionmap.get(keyname)
        if actionname:
            xkeycode = xboxkeys.get(actionname)
            if xkeycode:
                urllib2.urlopen(actionurl % (xkeycode))

if '__main__' == __name__:
    xev = xeventreader.XeventReader()
    while True:
        event = xev.getNextEvent()
        if isinstance(event, KeyPressEvent):
            print 'Key %d pressed' % event.detail
            if event.detail == 24:
                break
            sendCommand(event.detail)
