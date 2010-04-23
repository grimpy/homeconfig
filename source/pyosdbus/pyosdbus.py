#!/usr/bin/env python

import pyosd
import dbus
import dbus.service

class dbuspyosd(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName('test.grimpy.pyosdbus', bus = dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, '/test/grimpy/pyosdbus')
        self.osd = pyosd.osd(font='-adobe-helvetica-bold-*-*-*-34-*-*-*-*-*-*-*')
        self.osd.set_colour('green')
        self.osd.set_align(pyosd.ALIGN_CENTER)
        self.osd.set_pos(pyosd.POS_MID)
        self.osd.set_timeout(2)
        self.osd.set_shadow_offset(3)

    @dbus.service.method('test.grimpy.pyosdbus', in_signature='sn')
    def showPercentBar(self, text, percentage):
        self.osd.display(text)
        self.osd.display(percentage, pyosd.TYPE_PERCENT, 1)

    @dbus.service.method('test.grimpy.pyosdbus', in_signature='s')
    def showText(self, text):
        self.osd.display(text)
        self.osd.display('', pyosd.TYPE_STRING, 1)
