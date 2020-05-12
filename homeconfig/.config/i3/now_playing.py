from os.path import basename
from dbus.mainloop.glib import DBusGMainLoop
import dbus
import threading
import logging
import time
from gi.repository import GLib

from i3pystatus import Module, formatp
from i3pystatus.core.util import TimeWrapper


obj_dbus = "org.freedesktop.DBus"
path_dbus = "/org/freedesktop/DBus"
obj_player = "org.mpris.MediaPlayer2"
path_player = "/org/mpris/MediaPlayer2"
intf_props = obj_dbus + ".Properties"
intf_player = obj_player + ".Player"


class NoPlayerException(Exception):
    pass


class Player:
    def __init__(self, obj, callback):
        self._obj = obj
        self.logger = logging.getLogger("now_playing.player")
        self._callback = callback
        self._prop = dbus.Interface(self._obj, intf_props)
        self.api = dbus.Interface(self._obj, intf_player)
        self._prop.connect_to_signal("PropertiesChanged", self.update)

    def get(self, name, default=None):
        try:
            return self._prop.Get(intf_player, name)
        except dbus.DBusException:
            return default

    def update(self, *args):
        self.logger.warning("update {}".format(args))
        self._callback()

    def set(self, name, value):
        self._prop.Set(intf_player, name, value)


class NowPlaying(Module):
    """
    Shows currently playing track information. Supports media players that \
conform to the Media Player Remote Interfacing Specification.

    * Requires ``python-dbus`` from your distro package manager, or \
``dbus-python`` from PyPI.

    Left click on the module to play/pause, and right click to go to the next \
track.

    .. rubric:: Available formatters (uses :ref:`formatp`)

    * `{title}` — (the title of the current song)
    * `{album}` — (the album of the current song, can be an empty string \
(e.g. for online streams))
    * `{artist}` — (can be empty, too)
    * `{filename}` — (file name with out extension and path; empty unless \
title is empty)
    * `{song_elapsed}` — (position in the currently playing song, uses \
:ref:`TimeWrapper`, default is `%m:%S`)
    * `{song_length}` — (length of the current song, same as song_elapsed)
    * `{status}` — (play, pause, stop mapped through the `status` dictionary)
    * `{volume}` — (volume)

    .. rubric:: Available callbacks

    * ``playpause`` — Plays if paused or stopped, otherwise pauses.
    * ``next_song`` — Goes to next track in the playlist.
    * ``player_command`` — Invoke a command with the `MediaPlayer2.Player` \
interface. The method name and its arguments are appended as list elements.
    * ``player_prop`` — Get or set a property of the `MediaPlayer2.Player` \
interface. Append the property name to get, or the name and a value to set.

    `MediaPlayer2.Player` methods and properties are documented at \
https://specifications.freedesktop.org/mpris-spec/latest/Player_Interface.html

    Your player may not support the full interface.

    Example module registration with callbacks:

    ::

        status.register("now_playing",
            on_leftclick=["player_command", "PlayPause"],
            on_rightclick=["player_command", "Stop"],
            on_middleclick=["player_prop", "Shuffle", True],
            on_upscroll=["player_command", "Seek", -10000000],
            on_downscroll=["player_command", "Seek", +10000000])

    """

    settings = (
        (
            "player",
            "Player name. If not set, compatible players will be \
                    detected automatically.",
        ),
        ("status", "Dictionary mapping pause, play and stop to output text"),
        ("format", "formatp string"),
        ("color", "Text color"),
        ("format_no_player", "Text to show if no player is detected"),
        ("color_no_player", "Text color when no player is detected"),
        ("hide_no_player", "Hide output if no player is detected"),
    )

    hide_no_player = True
    format_no_player = "No Player"
    color_no_player = "#ffffff"

    format = "{title} {status}"
    color = "#ffffff"
    status = {
        "pause": "▷",
        "play": "▶",
        "stop": "◾",
    }
    statusmap = {
        "Playing": "play",
        "Paused": "pause",
        "Stopped": "stop",
        "Unknown": "stop",
    }

    on_leftclick = "playpause"
    on_rightclick = "next_song"

    player = None
    old_player = None

    def init(self):
        DBusGMainLoop(set_as_default=True)
        self._bus = dbus.SessionBus()
        self._obj = self._bus.get_object(
            "org.freedesktop.DBus", "/org/freedesktop/DBus"
        )
        self._obj.connect_to_signal("NameOwnerChanged", self.new_player)
        self._proxy = dbus.Interface(self._obj, "org.freedesktop.DBus")
        self._loop = GLib.MainLoop()
        self._players = {}

        threading.Thread(target=self.start).start()

    def start(self):
        time.sleep(2)
        self.find_players()
        self.update()
        self._loop.run()

    def new_player(self, name, *args):
        if name.startswith(obj_player):
            self.logger.warning(f"New {name}")
            obj = self._bus.get_object(name, path_player)
            player = Player(obj, self.update)
            if player.get("PlaybackStatus"):
                self._players[name] = player
            elif name in self._players:
                self._players.pop(name)
            self.update()

    def find_players(self):
        names = self._proxy.ListNames() + self._proxy.ListActivatableNames()
        for interface in names:
            if interface.startswith(obj_player):
                obj = self._bus.get_object(interface, path_player)
                player = Player(obj, self.update)
                if player.get("PlaybackStatus"):
                    self._players[interface] = player

    def get_current_player(self):
        order = ["Stopped", "Paused", "Playing"]
        score = 0
        bestplayer = None
        for player in self._players.values():
            status = player.get("PlaybackStatus")
            if status in order and order.index(status) > score:
                bestplayer = player
                score = order.index(status)
        return bestplayer

    def update(self):
        player = self.get_current_player()
        if not player:
            if self.hide_no_player:
                self.output = None
            else:
                self.output = {
                    "full_text": self.format_no_player,
                    "color": self.color_no_player,
                }
            if hasattr(self, "data"):
                del self.data
            return

        status = player.get("PlaybackStatus")
        currentsong = player.get("Metadata", {})
        volume = int(player.get("Volume", 0)) * 100
        position = player.get("Position", 0) or 0

        fdict = {
            "status": self.status[self.statusmap[status]],
            # TODO: Use optional(!) TrackList interface for this to
            # gain 100 % mpd<->now_playing compat
            "len": 0,
            "pos": 0,
            "volume": volume,
            "title": currentsong.get("xesam:title", ""),
            "album": currentsong.get("xesam:album", ""),
            "artist": ", ".join(currentsong.get("xesam:artist", "")),
            "song_length": TimeWrapper(
                (currentsong.get("mpris:length") or 0) / 1000 ** 2
            ),
            "song_elapsed": TimeWrapper(position / 1000 ** 2),
            "filename": "",
        }

        if not fdict["title"]:
            fdict["title"] = ".".join(
                basename((currentsong.get("xesam:url") or "")).split(".")[:-1]
            )

        self.data = fdict
        self.output = {
            "full_text": formatp(self.format, **fdict).strip(),
            "color": self.color,
        }
        self.send_output()

    def playpause(self):
        player = self.get_current_player()
        if player:
            player.api.PlayPause()

    def next_song(self):
        player = self.get_current_player()
        if player:
            player.api.Next()

    def player_command(self, command, *args):
        player = self.get_current_player()
        if player:
            getattr(player, command)(*args)
            player.api.PlayPause()

    def player_prop(self, name, value=None):
        player = self.get_current_player()
        if player:
            if value is None:
                player.get(name)
            else:
                player.set(name, value)
