# coding=utf-8
from i3pystatus import Status
import psutil
import netifaces

status = Status(standalone=True)

status.register("clock",
        format=" %a %-d %b %H:%M KW%V",)

status.register("pulseaudio",
    format="♪{volume}",)

status.register('now_playing',
                status={'play': '',
                'pause': '',
                'stop': ''})

status.register("temp",
    format="{temp:.0f}°C",)

status.register("cpu_usage_bar", format=' {usage_bar}', bar_type='vertical')
status.register("mem", format=' {used_mem} / {total_mem} GiB', divisor=1024**3)

status.register("battery",
    format="{status} {percentage:.0f}% {remaining:%E%hh:%Mm}",
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
    on_leftclick='sudo systemctl restart dhcpcd',
    format_up="{v4}",)

wfaces = list(filter(lambda x: x.startswith('w'), netifaces.interfaces()))
if wfaces:
    status.register("network",
        interface=wfaces[0],
        on_leftclick='wpa_gui',
        color_up='#FFFFFF',
        format_up="{essid}",)

status.register("network",
    interface="bond0",
    divisor=1024,
    start_color='white',
    format_up=" {bytes_recv}K  {bytes_sent}K",)

status.run()


