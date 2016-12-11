import i3
import os
import sys
import subprocess

TELEGRAMINSTANCE = 'telegram-desktop'
name = 'mynotification'


def workspacechange(ws, wsp, *args):
    if ws['change'] == 'urgent':
        urgent = False
        for ws in wsp:
            urgent |= ws['urgent']
        if urgent:
            print('Turn on notifcation')
            subprocess.Popen([name], shell=True)
        else:
            print('Turn off notifcation')
            subprocess.Popen("{} off".format(name), shell=True)


def windowchange(ws, wsp, *args):
    if ws['change'] == 'title':
        props = ws['container']['window_properties']
        if props['instance'] == TELEGRAMINSTANCE:
            print(props['title'])
            # if exact match then notifcation has been cleared
            if props['title'] == 'Telegram':
                cmd = ['wmctrl', '-b', 'remove,demands_attention', '-r', TELEGRAMINSTANCE, '-x']
                print('Request removal')
                subprocess.Popen(cmd)
            else:
                if not ws['container']['urgent']:
                    cmd = ['wmctrl', '-b', 'add,demands_attention', '-r', TELEGRAMINSTANCE, '-x']
                    print('Request adding')
                    subprocess.Popen(cmd)


socketpath = i3.get_socket_path()
if not os.path.exists(socketpath):
    print('I3 is not running')
    sys.exit(3)

try:
    i3.Subscription(workspacechange, 'workspace')
    i3.Subscription(windowchange, 'window')
except Exception as e:
    print('Failed', e)
    sys.exit(4)
