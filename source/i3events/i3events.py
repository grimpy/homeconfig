import i3
import os
import sys
import subprocess

TELEGRAMINSTANCE = 'Telegram'

def workspacechange(ws, wsp, *args):
    if ws['change'] == 'urgent':
        urgent = False
        for ws in wsp:
            urgent |= ws['urgent']
        if urgent:
            subprocess.Popen(['scrolllock'], shell=True)
        else:
            if os.path.exists('/tmp/scrolllock'):
                os.unlink('/tmp/scrolllock')
        print urgent


def windowchange(ws, wsp, *args):
    print ws['change']
    if ws['change'] == 'title':
        props = ws['container']['window_properties']
        if props['instance'] == TELEGRAMINSTANCE:
            print props['title']
            if not ws['container']['urgent']:
                cmd = ['wmctrl', '-b', 'add,demands_attention',
                    '-r', TELEGRAMINSTANCE, '-x']
                print cmd
                subprocess.Popen(cmd)

socketpath = i3.get_socket_path()
if not os.path.exists(socketpath):
    print 'I3 is not running'
    sys.exit(3)

try:
    i3.Subscription(workspacechange, 'workspace')
    i3.Subscription(windowchange, 'window')
except Exception, e:
    print 'Failed', e
    sys.exit(4)
