import xcb
from xcb.xproto import *
import xcb.render

def find_format(screen, depth, visual):
    for d in screen.depths:
        if d.depth == depth:
            for v in d.visuals:
                if v.visual == visual:
                    return v.format

    raise Exception("Failed to find an appropriate Render pictformat!")


class XeventReader:
    def __init__(self):
        self.conn = xcb.connect()
        self.conn.render = self.conn(xcb.render.key)

        self.setup = self.conn.get_setup()
        self.root = self.setup.roots[0]
        self.startup()

    def startup(self):
        depth = self.root.root_depth
        visual = self.root.root_visual

        window = self.conn.generate_id()
        pid = self.conn.generate_id()

        white = self.root.white_pixel
        name = 'XBMC Control'
        self.conn.core.CreateWindow(depth, window, self.root.root,
                               0, 0, 640, 480, 0,
                               WindowClass.InputOutput,
                               visual,
                               CW.BackPixel | CW.EventMask,
                               [ white, EventMask.ButtonPress | EventMask.KeyPress | EventMask.EnterWindow | EventMask.LeaveWindow | EventMask.Exposure ])
        self.conn.core.ChangeProperty(PropMode.Replace, self.root.root, xcb.XA_WM_CLASS, xcb.XA_STRING, 8, len(name), name)

        cookie = self.conn.render.QueryPictFormats()
        reply = cookie.reply()
        format = find_format(reply.screens[0], depth, visual)

        self.conn.core.ChangeProperty(PropMode.Replace, window, xcb.XA_WM_NAME, xcb.XA_STRING, 8, len(name), name)
        self.conn.render.CreatePicture(pid, window, format, 0, [])
        self.conn.core.MapWindow(window)
        self.conn.flush()

    def getNextEvent(self):
        return self.conn.wait_for_event()
