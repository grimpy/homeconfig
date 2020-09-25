# coding=utf-8
from i3pystatus import Status, IntervalModule
from i3pystatus.group import Group
import netifaces
import os
from isp_status import TelecomEgypt, VodaFone
import pulse
import now_playing2


class KernelStatus(IntervalModule):
    def run(self):
        release = os.uname().release
        msg = ""
        if not os.path.exists(os.path.join("/lib/modules", release)):
            msg = f"!{release}"
        self.output = {"full_text": msg, "color": "#FF0000"}


status = Status(standalone=True, logfile="$HOME/.cache/i3pystatus.log")
dategroup = Group()
dategroup.register(
    "clock",
    on_rightclick="mycal",
    on_leftclick='rofi -modi "Clock:roficlock" -show Clock',
    format="%H:%M",
)
dategroup.register("clock", on_rightclick="mycal", format="%a %-d %b %Y")
status.register(dategroup)

pulser = pulse.Pulser()
status.register(
    pulse.PulseAudio,
    pulser=pulser,
    format='{icon}{volume}',
    multi_colors=True,
)
status.register(
    pulse.PulseMic,
    pulser=pulser,
    format='{icon}',
)
status.register(
    pulse.PulseBluetooth,
    pulser=pulser,
    format='{icon} {bat}%',
)
status.register(
    "mpd",
    password="dummy",
    on_leftclick="switch_playpause",
    on_rightclick=["mpd_command", "stop"],
    on_middleclick=["mpd_command", "shuffle"],
    on_upscroll=["mpd_command", "seekcur -10"],
    status={"play": "", "pause": "", "stop": ""},
    on_downscroll=["mpd_command", "seekcur +10"],
)
status.register(now_playing2.NowPlaying, status={"play": "", "pause": "", "stop": ""})
status.register(
    "temp", format="{temp:.0f}°C",
)
status.register(
    "cpu_usage_bar",
    format='<span color="#FFFFFF"></span> {usage_bar}',
    hints={"markup": "pango"},
    on_rightclick="ftop",
    bar_type="vertical",
)
status.register(
    "mem",
    on_rightclick="ftop",
    color="#FFFFFF",
    hints={"markup": "pango"},
    format='<span color="#FFFFFF"></span> {percent_used_mem}%',
)
status.register(
    "battery",
    format='<span color="#FFFFFF">{status}</span>{percentage:.0f}%<span color="#FFFFFF"> {remaining:%E%hh:%Mm}</span>',
    hints={"markup": "pango"},
    alert=True,
    alert_percentage=5,
    full_color="#FFFFFF",
    status={"DIS": "", "CHR": "", "FULL": "⚡",},
)
group = Group()
group.register(
    "network",
    interface="bond0",
    divisor=1024,
    start_color="white",
    on_rightclick="mynet",
    format_up="{bytes_recv}K {bytes_sent}K",
)
group.register(
    "network",
    interface="bond0",
    color_up="#FFFFFF",
    on_rightclick="sudo systemctl restart dhcpcd",
    format_up="{v4:.<7}",
)

wfaces = list(filter(lambda x: x.startswith("w"), netifaces.interfaces()))
if wfaces:
    group.register(
        "network",
        interface=wfaces[0],
        on_rightclick="wpa_gui -i {}".format(wfaces[0]),
        color_up="#FFFFFF",
        format_up="{essid}",
    )

status.register(group)


def bond_icon(data):
    if data.startswith(("en", "eth")):
        return ""
    else:
        return ""


status.register(
    "file",
    components={"bond": (bond_icon, "/sys/class/net/bond0/bonding/active_slave")},
    format="{bond}",
)
status.register(VodaFone, on_leftclick="refresh", interval=3601)
#status.register(TelecomEgypt, on_leftclick="refresh", interval=3600)
status.register(KernelStatus, interval=3600)

status.run()
