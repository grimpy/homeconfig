import i3
import os
import sys
import subprocess

TELEGRAMINSTANCE = 'telegram-desktop'
NOTIFY = 'mynotification'
LOCKFILE = "/tmp/mynotification/lock"
X11CMD_ENABLE = ['wmctrl', '-b', 'add,demands_attention', '-r', TELEGRAMINSTANCE, '-x']
X11CMD_DISABLE = ['wmctrl', '-b', 'remove,demands_attention', '-r', TELEGRAMINSTANCE, '-x']
SWAYCMD_ENABLE = ['swaymsg', '-t', 'command', '[app_id={}]'.format(TELEGRAMINSTANCE), 'urgent', 'enable']
SWAYCMD_DISABLE = ['swaymsg', '-t', 'command', '[app_id={}]'.format(TELEGRAMINSTANCE), 'urgent', 'disable']
iswayland = 'WAYLAND_DISPLAY' in os.environ
print(iswayland)


def workspacechange(ws, wsp, *args):
    if ws['change'] == 'urgent':
        urgent = False
        for ws in wsp:
            urgent |= ws['urgent']
        if urgent:
            print('Turn on notifcation')
            if not os.path.exists(LOCKFILE):
                subprocess.Popen([NOTIFY])
        else:
            print('Turn off notifcation')
            try:
                os.remove(LOCKFILE)
            except FileNotFoundError:
                pass

def get_instance_title(ws):
    props = ws['container'].get('window_properties')
    if props:
        return props['instance'], props['title']
    else:
        return ws['container']['app_id'], ws['container']['name']
    

def windowchange(ws, wsp, *args):
    if ws['change'] == 'title':
        instance, title = get_instance_title(ws)
        if instance == TELEGRAMINSTANCE:
            print(title)
            # if exact match then notifcation has been cleared
            if title == 'Telegram':
                print('Request removal')
                if iswayland:
                    subprocess.run(SWAYCMD_DISABLE)
                else:
                    subprocess.run(X11CMD_DISABLE)

            else:
                if not ws['container']['urgent']:
                    print('Request adding')
                    if iswayland:
                        subprocess.run(SWAYCMD_ENABLE)
                    else:
                        subprocess.run(X11CMD_ENABLE)


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
