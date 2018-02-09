# coding=utf-8
from i3pystatus import Status
import psutil
import subprocess
import netifaces

def spawn(*args):
    def wrapper(self):
        subprocess.Popen(args)
    return wrapper

status = Status(standalone=True)

#clock.Clock.on_leftclick = ""
status.register("pulseaudio",
    format="♪{volume}",)

status.register('now_playing',
                status={'play': '',
                'pause': '',
                'stop': ''})

status.run()


