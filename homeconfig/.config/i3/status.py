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
status.register("clock",
        on_leftclick=[spawn('xterm', '-class', 'Float', '-geometry', '74x9', '-e', 'cal -3 -w; read')],
        #on_leftclick=[['wpa_gui']],
        format=" %a %-d %b %H:%M")

status.register("pulseaudio",
    format="♪{volume}",)

status.register('now_playing',
                status={'play': '',
                'pause': '',
                'stop': ''})

status.register("temp",
    format="{temp:.0f}°C",)

status.register("cpu_usage_bar",
                format='<span color="#FFFFFF"></span> {usage_bar}',
                hints = {"markup": "pango"},
                on_leftclick=[spawn('xterm', '-class', 'Float', '-geometry', '120x40', '-e', 'htop')],
                bar_type='vertical'
                )
status.register("mem",
                hints = {"markup": "pango"},
                format='<span color="#FFFFFF"> </span> {used_mem} / {total_mem} GiB',
                divisor=1024**3)

status.register("battery",
    format='<span color="#FFFFFF">{status}</span> {percentage:.0f}% <span color="#FFFFFF">{remaining:%E%hh:%Mm}</span>',
    hints = {"markup": "pango"},
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "⚡",
    },)

status.register("network",
    interface="bond0",
    color_up='#FFFFFF',
    on_leftclick=[spawn('sudo', 'systemctl', 'restart', 'dhcpcd')],
    format_up="{v4}",)

wfaces = list(filter(lambda x: x.startswith('w'), netifaces.interfaces()))
if wfaces:
    status.register("network",
        interface=wfaces[0],
        on_leftclick=[spawn('wpa_gui', '-i', 'wlan0')],
        color_up='#FFFFFF',
        format_up="{essid}",)

status.register("network",
    interface="bond0",
    divisor=1024,
    start_color='white',
    format_up=" {bytes_recv}K  {bytes_sent}K",)

status.register("file",
        components={'bond': (str, '/sys/class/net/bond0/bonding/active_slave')},
        format="{bond}")

status.run()


