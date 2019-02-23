# coding=utf-8
from i3pystatus import Status, IntervalModule
from i3pystatus.group import Group
import netifaces


class VodaFone(IntervalModule):
    interval = 3600
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        try:
            import vodafone
            self.vf = vodafone.Vodafone()
        except ImportError:
            self.vf = None

    def run(self):
        if self.vf is None:
            return
        try:
            self.vf.parse()
        except:
            return

        percent = (self.vf.used / self.vf.limit) * 100
        remainingpercent = 100 - (self.vf.daysleft / self.vf.totaldays) * 100
        if remainingpercent < percent:
            color = "#FF0000"
        else:
            color = "#FFFFFF"
        self.data = self.vf.__dict__
        self.output = {"full_text": "{limit:.0f}% R{remaining}d ({remper:.2f}%)".format(limit=percent, remaining=self.vf.daysleft, remper=remainingpercent),
                       'color': color}

    def refresh(self):
        self.run()


class TelecomEgypt(IntervalModule):
    interval = 3600
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        try:
            import telecomegypt
            self.te = telecomegypt.TelecomEgypt('01550165809', 'bZbbrcgicCUq9grzG0qJtNTWfJrxXmAOUn5W5xqMsiY=')
            self.te.login()
        except ImportError:
            self.te = None

    def run(self):
        if self.te is None:
            return
        try:
            data = self.te.get_data()
        except:
            return

        mobiledata = data['body']['detailedLineUsageList'][0]
        percent = mobiledata['usagePercentage']
        remainingpercent = 100 - (mobiledata['remainingDaysForRenewal'] / 31) * 100
        if remainingpercent < percent:
            color = "#FF0000"
        else:
            color = "#FFFFFF"
        self.data = self.te.__dict__
        self.output = {"full_text": "{limit:.0f}% R:{remaining}d ({remper:.0f}%)".format(limit=percent, remaining=mobiledata['remainingDaysForRenewal'], remper=remainingpercent),
                       'color': color}

    def refresh(self):
        self.run()



status = Status(standalone=True, logfile='$HOME/.cache/i3pystatus.log')
dategroup = Group()
dategroup.register("clock",
               on_rightclick='mycal',
               on_leftclick='rofi -modi "Clock:roficlock" -show Clock',
               format="%H:%M")
dategroup.register("clock",
               on_rightclick='mycal',
               format="%a %-d %b %Y")
status.register(dategroup)
status.register("pulseaudio",
                format="♪{volume}", bar_type="horizontal",
                multi_colors=True)
status.register("mpd",
    on_leftclick="switch_playpause",
    on_rightclick=["mpd_command", "stop"],
    on_middleclick=["mpd_command", "shuffle"],
    on_upscroll=["mpd_command", "seekcur -10"],
    status={'play': '',
            'pause': '',
            'stop': ''},
    on_downscroll=["mpd_command", "seekcur +10"])
status.register('now_playing',
                status={'play': '',
                        'pause': '',
                        'stop': ''})
status.register("temp", format="{temp:.0f}°C",)
status.register("cpu_usage_bar",
                format='<span color="#FFFFFF"></span> {usage_bar}',
                hints = {"markup": "pango"},
                on_rightclick='ftop',
                bar_type='vertical'
                )
status.register("mem",
                on_rightclick='ftop',
                color='#FFFFFF',
                hints = {"markup": "pango"},
                format='<span color="#FFFFFF"></span> {percent_used_mem}%')
status.register("battery",
                format='<span color="#FFFFFF">{status}</span>{percentage:.0f}%<span color="#FFFFFF"> {remaining:%E%hh:%Mm}</span>',
                hints = {"markup": "pango"},
                alert=True,
                alert_percentage=5,
                full_color="#FFFFFF",
                status={
                       "DIS": "",
                       "CHR": "",
                       "FULL": "⚡",
                })
group = Group()
group.register("network",
               interface="bond0",
               divisor=1024,
               start_color='white',
               on_rightclick="mynet",
               format_up="{bytes_recv}K {bytes_sent}K",)
group.register("network",
               interface="bond0",
               color_up='#FFFFFF',
               on_rightclick='sudo systemctl restart dhcpcd',
               format_up="{v4:.<7}",)

wfaces = list(filter(lambda x: x.startswith('w'), netifaces.interfaces()))
if wfaces:
    group.register("network",
                   interface=wfaces[0],
                   on_rightclick='wpa_gui -i {}'.format(wfaces[0]),
                   color_up='#FFFFFF',
                   format_up="{essid}",)

status.register(group)

def bond_icon(data):
    if data.startswith('en'):
        return ''
    else:
        return ''

status.register("file",
               components={'bond': (bond_icon, '/sys/class/net/bond0/bonding/active_slave')},
               format="{bond}")
#status.register(VodaFone, on_leftclick="refresh", interval=3600)
status.register(TelecomEgypt, on_leftclick="refresh", interval=3600)

status.run()


