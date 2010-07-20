import xcb
from xcb.xproto import *
import xcb.render
import urllib2
import pdb
url = "http://1.1.0.3/xbmcCmds/xbmcHttp?command=SendKey(%s)"


#Key 36 pressed  Enter
#Key 22 pressed backspace Key 65 pressed space
xboxdefinekeys = '''
#define KEY_BUTTON_A 256
#define KEY_BUTTON_B 257
#define KEY_BUTTON_X 258
#define KEY_BUTTON_Y 259
#define KEY_BUTTON_BLACK 260
#define KEY_BUTTON_WHITE 261
#define KEY_BUTTON_LEFT_TRIGGER 262
#define KEY_BUTTON_RIGHT_TRIGGER 263

#define KEY_BUTTON_LEFT_THUMB_STICK 264
#define KEY_BUTTON_RIGHT_THUMB_STICK 265

#define KEY_BUTTON_RIGHT_THUMB_STICK_UP 266
#define KEY_BUTTON_RIGHT_THUMB_STICK_DOWN 267
#define KEY_BUTTON_RIGHT_THUMB_STICK_LEFT 268
#define KEY_BUTTON_RIGHT_THUMB_STICK_RIGHT 269

#// Digital - don't change order
#define KEY_BUTTON_DPAD_UP 270
#define KEY_BUTTON_DPAD_DOWN 271
#define KEY_BUTTON_DPAD_LEFT 272
#define KEY_BUTTON_DPAD_RIGHT 273

#define KEY_BUTTON_START 274
#define KEY_BUTTON_BACK 275'''

xkeys = {65: "SPACE" , 113: "LEFT", 111:"UP", 116:"DOWN", 114: "RIGHT", 36: "ENTER", 22: "BACKSPACE"}


def parseKeys(xboxdefinekeys):
    xboxkeys = {}
    for line in xboxdefinekeys.splitlines():
        items = line.split()
        if len(items) == 3:
            xboxkeys[items[1]] = items[2]
    return xboxkeys


xboxkeys = parseKeys(xboxdefinekeys)
keymap = {"LEFT":"KEY_BUTTON_DPAD_LEFT", "UP": "KEY_BUTTON_DPAD_UP", "DOWN":"KEY_BUTTON_DPAD_DOWN",
            "RIGHT":"KEY_BUTTON_DPAD_RIGHT", "ENTER": "KEY_BUTTON_A", "BACKSPACE":"KEY_BUTTON_B"}

def find_format(screen):
    for d in screen.depths:
        if d.depth == depth:
            for v in d.visuals:
                if v.visual == visual:
                    return v.format

    raise Exception("Failed to find an appropriate Render pictformat!")


def startup():
    white = setup.roots[0].white_pixel

    conn.core.CreateWindow(depth, window, root,
                           0, 0, 640, 480, 0,
                           WindowClass.InputOutput,
                           visual,
                           CW.BackPixel | CW.EventMask,
                           [ white, EventMask.ButtonPress | EventMask.KeyPress | EventMask.EnterWindow | EventMask.LeaveWindow | EventMask.Exposure ])

    cookie = conn.render.QueryPictFormats()
    reply = cookie.reply()
    format = find_format(reply.screens[0])

    name = 'X Python Binding Demo'
    conn.core.ChangeProperty(PropMode.Replace, window, xcb.XA_WM_NAME, xcb.XA_STRING, 8, len(name), name)
    conn.render.CreatePicture(pid, window, format, 0, [])
    conn.core.MapWindow(window)
    conn.flush()


def sendCommand(key):
    keyname = xkeys.get(key)
    if keyname:
        xkeyname = keymap.get(keyname)
        if xkeyname:
            xkeycode = xboxkeys.get(xkeyname)
            if xkeycode:
                urllib2.urlopen(url % (xkeycode))


def run():
    startup()
    print 'Click in window to exit.'

    while True:
        try:
            event = conn.wait_for_event()
        except xcb.ProtocolException, error:
            print "Protocol error %s received!" % error.__class__.__name__
            break
        except Exception, error:
            print "Unexpected error received: %s" % error.message
            break

        if isinstance(event, EnterNotifyEvent):
            print 'Enter (%d, %d)' % (event.event_x, event.event_y)
        elif isinstance(event, LeaveNotifyEvent):
            print 'Leave (%d, %d)' % (event.event_x, event.event_y)
        elif isinstance(event, KeyPressEvent):
            print 'Key %d pressed' % event.detail
            if event.detail == 24:
                break
            sendCommand(event.detail)

    conn.disconnect()



conn = xcb.connect()
conn.render = conn(xcb.render.key)

setup = conn.get_setup()
root = setup.roots[0].root
depth = setup.roots[0].root_depth
visual = setup.roots[0].root_visual

window = conn.generate_id()
pid = conn.generate_id()
run()
