import threading
import subprocess
import logging

from i3pystatus import Module, IntervalModule
from i3pystatus.core.color import ColorRangeModule
import pulsectl
import dbus
import time
import socket
import struct


class BoseConnect:
    HANDSHAKE = b"\x00\x01\x01\x00"
    HANDSHAKE_ACK = b"\x00\x01\x03\x05"
    BATERY = b"\x02\x02\x01\x00"
    BATERY_ACK = b"\x02\x02\x03\x01"

    def __init__(self, address):
        self._address = address
        self._sock = None
        try:
            self.connect()
        except OSError:
            pass

    def connect(self):
        if self._sock:
            self._sock.close()
        self._sock = socket.socket(
            socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM
        )
        self._sock.connect((self._address, 8))
        self.command(self.HANDSHAKE, self.HANDSHAKE_ACK, 5)

    def _command(self, msg, ack, responselength):
        self._sock.sendall(msg)
        assert self._sock.recv(len(ack)) == ack
        return self._sock.recv(responselength)

    def command(self, msg, ack, responselength):
        try:
            return self._command(msg, ack, responselength)
        except (OSError, AssertionError):
            self.connect()
            return self._command(msg, ack, responselength)

    def get_battery(self):
        try:
            info = self.command(self.BATERY, self.BATERY_ACK, 1)
            return struct.unpack("b", info)[0]
        except (OSError, AssertionError):
            return -1


class Pulser:
    def __init__(self):
        self._pulse = None
        self._callbacks = []
        self.logger = logging.getLogger("pulser")
        self.logger.setLevel(logging.DEBUG)
        self._started = False
        self.lock = threading.Lock()

    @property
    def api(self):
        if self._pulse is None:
            self._pulse = pulsectl.Pulse()
        if not self._pulse.connected:
            self._pulse.connect()
        return self._pulse

    def __enter__(self):
        self.lock.acquire()
        return self.api

    def __exit__(self, *args):
        self.lock.release()

    def add_callback(self, func):
        self._callbacks.append(func)

    def start(self):
        if not self._started:
            threading.Thread(target=self.listen).start()
            self._started = True
        self.run_callbacks()

    def run_callbacks(self):
        for callback in self._callbacks:
            try:
                callback()
            except Exception as e:
                self.logger.error("failed to execute callback", exc_info=e)

    @property
    def current_sink(self):
        with self as api:
            return self._get_best_dev(api.sink_list())

    @property
    def current_mic(self):
        with self as api:
            return self._get_best_dev(api.source_list())

    def _get_best_dev(self, devs):
        bdev = None
        for dev in devs:
            if dev.description.startswith("Monitor"):
                continue
            if dev.state == pulsectl.PulseStateEnum.running:
                return dev
            if bdev is None:
                bdev = dev
            if "Built-in" not in dev.description:
                bdev = dev
        return bdev

    def listen(self):
        proc = subprocess.Popen(["pactl", "subscribe"], stdout=subprocess.PIPE)
        while True:
            event = proc.stdout.readline().decode()
            if 'on client' in event:
                continue
            self.run_callbacks()
            if proc.poll() is not None:
                time.sleep(5)
                proc = subprocess.Popen(["pactl", "subscribe"], stdout=subprocess.PIPE)


class PulseMic(Module):
    settings = ("format",)
    format = "{icon}"
    on_rightclick = "switch_mute"
    on_leftclick = "switch_noise"
    modules = [("module-null-sink", "sink_name=nui_mic_denoised_out rate=48000"),
               ("module-ladspa-sink", "sink_name=nui_mic_raw_in sink_master=nui_mic_denoised_out label=noise_suppressor_mono plugin=/usr/lib/librnnoise_ladspa.so control=95"),
               ("module-loopback", "source=alsa_input.pci-0000_00_1f.3.analog-stereo sink=nui_mic_raw_in channels=1 latency_msec=1"),
               ("module-remap-source", "master=nui_mic_denoised_out.monitor source_name=nui_mic_remap source_properties=device.description=NoiseTorch")]

    def __init__(self, *args, pulser=None, **kwargs):
        self.pulser = pulser or Pulser()
        super().__init__(*args, **kwargs)

    def init(self):
        self.pulser.add_callback(self.update)
        self.pulser.start()

    def update(self):
        """Updates self.output"""
        mic = self.pulser.current_mic

        if mic.mute:
            micicon = ""
            miccolor = "#ff0000"
        else:
            micicon = ""
            miccolor = "#ffffff"
        with self.pulser as api:
            if self._find_module(api, self.modules[-2]):
                miccolor = "#ff00ff"
            elif mic.state == pulsectl.PulseStateEnum.running:
                miccolor = "#00ff00"

        self.output = {
            "color": miccolor,
            "full_text": self.format.format(icon=micicon,),
        }

        self.send_output()

    def switch_mute(self):
        mic = self.pulser.current_mic
        with self.pulser as api:
            if mic.mute:
                api.source_mute(mic.index, False)
            else:
                api.source_mute(mic.index, True)

    def _find_module(self, api, module, modules=None):
        if modules is None:
            modules = api.module_list()

        for loaded_mod in modules:
            if loaded_mod.name == module[0] and loaded_mod.argument == module[1]:
                return loaded_mod
        return None

    def switch_noise(self):
        with self.pulser as api:
            loaded_modules = api.module_list()
            if not self._find_module(api, self.modules[-2], loaded_modules):
                for modname, args in self.modules:
                    api.module_load(modname, args)
            else:
                for modname, args in self.modules[::-1]:
                    mod = self._find_module(api, (modname, args), loaded_modules)
                    if mod:
                        api.module_unload(mod.index)


class PulseBluetooth(IntervalModule):
    settings = ("format", "address")
    format = "{icon} {name} {bat}%"
    icon = ""
    interval = 600
    address = "04:52:C7:0A:5E:0B"
    on_rightclick = "switch_profile"
    on_leftclick = "connect"

    def __init__(self, *args, pulser=None, **kwargs):
        self.pulser = pulser or Pulser()
        self.battery = 0
        self.lastupdate = 0
        super().__init__(*args, **kwargs)

    def init(self):
        self.pulser.add_callback(self.update)
        self.pulser.start()
        self.bose = BoseConnect(self.address)

    def update(self):
        """Updates self.output"""
        name = ""
        card = self.get_bluetooth_card()
        if card:
            if self.lastupdate + 300 < time.time():
                self.lastupdate = time.time()
                bat = self.bose.get_battery()
                if bat != -1:
                    self.battery = bat
            name = card.proplist["device.description"]
            if card.profile_active.name == "headset_head_unit":
                color = "#00ff00"
            else:
                color = "#0080ff"
        else:
            color = "#ffffff"

        self.output = {
            "color": color,
            "full_text": self.format.format(
                icon=self.icon, name=name, bat=self.battery
            ),
        }

        self.send_output()

    def run(self):
        self.update()

    def get_profile_by_name(self, card, name, fallback=None):
        fallback_profile = None
        for profile in card.profile_list:
            if profile.available:
                if profile.name.startswith(name):
                    self.logger.warning(f"Returning {profile.name}")
                    return profile
                elif fallback and profile.name.startswith(fallback):
                    fallback_profile = profile
        if fallback_profile:
            self.logger.warning(f"Returning {profile.name}")

        return fallback_profile

    def switch_profile(self):
        card = self.get_bluetooth_card()
        if not card:
            return
        if card.profile_active.name.startswith("a2dp_sink"):
            newprofile = self.get_profile_by_name(card, "headset_head_unit")
        else:
            newprofile = self.get_profile_by_name(card, "a2dp_sink_aac", "a2dp_sink")
        if newprofile:
            with self.pulser as api:
                api.card_profile_set(card, newprofile)

    def get_bluetooth_card(self):
        with self.pulser as api:
            for card in api.card_list():
                if card.name.startswith("bluez_card"):
                    return card

    def connect(self):
        address = self.address.replace(":", "_")
        objectpath = f"/org/bluez/hci0/dev_{address}"
        bus = dbus.SystemBus()
        obj = bus.get_object("org.bluez", objectpath)
        interface = dbus.Interface(obj, "org.bluez.Device1")
        interface.Connect()


class PulseAudio(Module, ColorRangeModule):
    """
    Shows volume of default PulseAudio sink (output).

    - Requires amixer for toggling mute and incrementing/decrementing volume on scroll.
    - Depends on the PyPI colour module - https://pypi.python.org/pypi/colour/0.0.5

    .. rubric:: Available formatters

    * `{volume}` — volume in percent (0...100)
    * `{db}` — volume in decibels relative to 100 %, i.e. 100 % = 0 dB, 50 % = -18 dB, 0 % = -infinity dB
      (the literal value for -infinity is `-∞`)
    * `{muted}` — the value of one of the `muted` or `unmuted` settings
    * `{volume_bar}` — unicode bar showing volume
    """

    settings = (
        "format",
        ("format_muted", "optional format string to use when muted"),
        "muted",
        "unmuted",
        "color_muted",
        "color_unmuted",
        ("step", "percentage to increment volume on scroll"),
        ("sink", "sink name to use, None means pulseaudio default"),
        (
            "multi_colors",
            "whether or not to change the color from "
            "'color_muted' to 'color_unmuted' based on volume percentage",
        ),
    )

    muted = "M"
    unmuted = ""
    format = "♪: {volume}"
    format_muted = None
    color_muted = "#FF0000"
    color_unmuted = "#FFFFFF"

    step = 5
    multi_colors = False

    on_rightclick = "switch_mute"
    on_doubleleftclick = "change_sink"
    on_leftclick = "pavucontrol"
    on_upscroll = "increase_volume"
    on_downscroll = "decrease_volume"

    def __init__(self, *args, pulser=None, **kwargs):
        self.pulser = pulser or Pulser()
        super().__init__(*args, **kwargs)

    def init(self):
        self.colors = self.get_hex_color_range(
            self.color_muted, self.color_unmuted, 100
        )
        self.pulser.add_callback(self.update)
        self.pulser.start()

    def update(self):
        """Updates self.output"""
        sink = self.pulser.current_sink
        volume_percent = round(100 * sink.volume.value_flat)
        muted = sink.mute

        if self.multi_colors and not muted:
            color = self.get_gradient(volume_percent, self.colors)
        else:
            color = self.color_muted if muted else self.color_unmuted

        if muted and self.format_muted is not None:
            output_format = self.format_muted
        else:
            output_format = self.format

        if muted:
            icon = ""
        else:
            icon = ""

        self.output = {
            "color": color,
            "full_text": output_format.format(
                muted=muted, volume=volume_percent, icon=icon
            ),
        }

        self.send_output()

    def switch_mute(self):
        sink = self.pulser.current_sink
        with self.pulser as api:
            if sink.mute:
                api.sink_mute(sink.index, False)
            else:
                api.sink_mute(sink.index, True)

    def increase_volume(self):
        sink = self.pulser.current_sink
        with self.pulser as api:
            api.volume_change_all_chans(sink, 0.05)

    def decrease_volume(self):
        sink = self.pulser.current_sink
        # subprocess.run(["pactl", "set-sink-volume", sink.name, "-5%"])
        with self.pulser as api:
            api.volume_change_all_chans(sink, -0.05)
