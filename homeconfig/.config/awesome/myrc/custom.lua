local awful = require("awful")
local client = require("client")
local naughty = require("naughty")
local tag = require("tag")
module("myrc.custom")

browser = "chromium"
terminal = "urxvtc"
autostart = true
modkey = "Mod4"
modkey2 = "Mod1"

shiftytags = {
    ["1:term"] = { position = 1, exclusive = true, max_clients = 4, spawn = terminal, layout = awful.layout.suit.fair},
    ["2:im"]  = { position = 2, exclusive = true, spawn = "pidgin", layout = awful.layout.suit.floating, },
    ["3:web"]  = { position = 3, exclusive = true, spawn = browser, screen = 2, layout = awful.layout.suit.max, icon="/usr/share/icons/Tango/16x16/apps/web-browser.png"},
    ["4:mail"]  = { position = 4, exclusive = true, spawn = "thunderbird", layout = awful.layout.suit.max, screen = 1},
    ["5:fs"]  = { position = 5, exclusive = true, spawn = "thunar", layout = awful.layout.suit.floating, },
    ["6:edit"]  = { position = 6, exclusive = true, spawn = "geany", screen = 1, nopopup = true, layout = awful.layout.suit.max, },
    ["7:media"]  = { position = 7, exclusive = true, screen = 2, nopopup = true, layout = awful.layout.suit.floating, },
}
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ "Mod1" }, 1, awful.mouse.client.move),
    awful.button({ "Mod1" }, 3, awful.mouse.client.resize))

shiftyapps = {
         { match = { "Chrome", "Chromium", "Navigator", "Namoroka","Firefox"} , tag = "3:web" } ,
         { match = { "Thunderbird"} , tag = "4:mail" } ,
         { match = { "Pidgin", "Skype"} , tag = "2:im" } ,
         { match = { "xterm", "urxvt", "Terminator"} , honorsizehints = false, slave = true, tag = "1:term" } ,
         { match = { "Thunar", "pcmanfm", "xarchiver" }, tag = "5:fs" } ,
         { match = { "Geany" }, tag = "6:edit" } ,
         { match = { "Eclipse" }, tag = "6:edit" } ,
         { match = { "MPlayer" }, tag = "7:media" } ,
         { match = { "Audacious" }, tag = "7:media" } ,
         { match = { "" }, buttons =  clientbuttons },
}

shiftydefaults = {
  layout = awful.layout.suit.floating,
  ncol = 1,
  mwfact = 0.60,
  floatBars=true,
  run = function(tag) naughty.notify({ text = tag.name }) end
}

keybindings = awful.util.table.join(
    awful.key({ modkey2, "Control" }, "c", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "F2", function () awful.util.spawn("mpc toggle") end),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn("mpc prev") end),
    awful.key({ modkey,           }, "F4", function () awful.util.spawn("mpc next") end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("thunar") end),
    awful.key({ modkey, }, "l", function () awful.util.spawn("alock -auth pam -bg blank") end),
    awful.key({ modkey2, "Control" }, "s", function () awful.util.spawn("skype") end),
    awful.key({ modkey2, "Control" }, "m", function () awful.util.spawn("pidgin") end),
    awful.key({ modkey2, "Control" }, "k", function () awful.util.spawn("geany") end))

