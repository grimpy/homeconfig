import i3
import os
import sys
import subprocess

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

socketpath = i3.get_socket_path()
if not os.path.exists(socketpath):
    print 'I3 is not running'
    sys.exit(3)

try:
    i3.Subscription(workspacechange, 'workspace')
except Exception, e:
    print 'Failed', e
    sys.exit(4)
