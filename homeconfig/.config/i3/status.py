# coding=utf-8
from i3pystatus import Status, IntervalModule
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
        self.vf.parse()
        daypercent = (self.vf.dayused / self.vf.daylimit) * 100
        nightpercent = (self.vf.nightused / self.vf.nightlimit) * 100
        remainingpercent = (self.vf.daysleft / self.vf.totaldays) * 100
        if remainingpercent < daypercent or remainingpercent < nightpercent:
            color = "#FF0000"
        else:
            color = "#00FF00"
        self.data = self.vf.__dict__
        self.output = {"full_text": "{day:.0f}% {night:.0f}% {remaining}".format(day=daypercent, night=nightpercent, remaining=self.vf.daysleft),
                       'color': color}

    def refresh(self):
        self.run()



status = Status(standalone=True)

status.register("clock",
        on_rightclick='mycal',
        format=" %a %-d %b %H:%M")

status.register("pulseaudio",
    format="♪{volume}", bar_type="horizontal",
    multi_colors=True)

status.register('now_playing',
                status={'play': '',
                'pause': '',
                'stop': ''})

status.register("temp",
    format=" {temp:.0f}°C",)

status.register("cpu_usage_bar",
                format='<span color="#FFFFFF"></span> {usage_bar}',
                hints = {"markup": "pango"},
                on_rightclick='xterm -class Float -geometry 120x40 -e htop',
                bar_type='vertical'
                )
status.register("mem_bar",
                multi_colors=True,
                on_rightclick='xterm -class Float -geometry 120x40 -e htop',
                format='{used_mem_bar}')

status.register("battery",
    format='<span color="#FFFFFF">{status}</span> {percentage:.0f}% <span color="#FFFFFF">{remaining:%E%hh:%Mm}</span> ',
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
    on_rightclick='sudo systemctl restart dhcpcd',
    format_up="{v4}",)

status.register(VodaFone, on_leftclick="refresh", interval=3600)
wfaces = list(filter(lambda x: x.startswith('w'), netifaces.interfaces()))
if wfaces:
    status.register("network",
        interface=wfaces[0],
        on_rightclick='wpa_gui -i {}'.format(wfaces[0]),
        color_up='#FFFFFF',
        format_up="{essid}",)

status.register("network",
    interface="bond0",
    divisor=1024,
    start_color='white',
    on_rightclick="xterm -class Float -geometry 150x50 -e 'sudo jnettop -i bond0'",
    format_up=" {bytes_recv}K  {bytes_sent}K",)

status.register("file",
        components={'bond': (str, '/sys/class/net/bond0/bonding/active_slave')},
        format="{bond}")

status.run()


