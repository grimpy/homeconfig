# coding=utf-8
from i3pystatus import Status
import psutil

status = Status(standalone=True)

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
        format="%a %-d %b %H:%M KW%V",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="♪{volume}",)

status.register('now_playing',
                status={'play': '',
                'pause': '',
                'stop': ''})

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
    format="{temp:.0f}°C",)

status.register("cpu_usage_graph", format='{cpu_graph}', graph_width=5)
status.register("mem_bar", format='{used_mem_bar}')

status.register("battery",
    format="{status} {percentage:.0f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "",
        "CHR": "",
        "FULL": "⚡",
    },)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface="bond0",
    color_up='#FFFFFF',
    on_leftclick='sudo systemctl restart dhcpcd',
    format_up="{v4}",)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlan0",
    on_leftclick='wpa_gui',
    color_up='#FFFFFF',
    format_up="{essid}",)

status.register("network",
    interface="bond0",
    divisor=1024,
    start_color='white',
    format_up=" {bytes_recv}K  {bytes_sent}K",)


# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
#status.register("mpd",
#    format="{title}{status}{album}",
#    status={
#        "pause": "▷",
#        "play": "▶",
#        "stop": "◾",
#    },)

status.run()


