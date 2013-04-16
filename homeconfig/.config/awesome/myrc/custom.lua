local awful = require("awful")
local client = client
local screen = screen
local mouse = mouse
local naughty = require("naughty")
local shifty = require("shifty")
local ipairs = ipairs
local os = require("os")

module("myrc.custom")
shifty.config.sloppy = false
binhome = os.getenv("HOME") .. "/mygit/scripts/bin/"

browser = binhome .. "browser"
terminal = "urxvtc"
autostart = true
modkey = "Mod4"
modkey2 = "Mod1"
LCD = screen.count()
VGA = 1

shiftytags = {
    ["1:term"] = { position=1, key=1, exclusive=true, max_clients=4, screen=VGA, spawn=terminal, layout=awful.layout.suit.fair.horizontal},
    ["2:im"] = { position=2, key=2, exclusive=true, spawn="pidgin", screen=VGA, layout=awful.layout.suit.fair.horizontal, },
    ["3:web"] = { position=3, key=3, exclusive=true, spawn=browser, screen=LCD, layout=awful.layout.suit.max, icon="/usr/share/icons/gnome/16x16/apps/web-browser.png"},
    ["4:mail"] = { position=4, key=4, exclusive=true, spawn="thunderbird", layout=awful.layout.suit.max, screen=VGA},
    ["5:fs"] = { position=5, key=5, exclusive=true, spawn="nautilus", layout=awful.layout.suit.floating, screen=LCD},
    ["6:edit"] = { position=6, key=6, exclusive=true, spawn="gvim", screen=VGA, nopopup=true, layout=awful.layout.suit.max, },
    ["7:media"] = { position=7, key=7, exclusive=true, screen=LCD, nopopup=true, layout=awful.layout.suit.floating, },
    ["9:mediafs"] = { position=9, key=9, exclusive=true, screen=LCD, nopopup=true, layout=awful.layout.suit.max.fullscreen, },
    ["8:emu"] = { position=8, key=8, exclusive=true, spawn="VirtualBox", screen=LCD, nopopup=true, layout=awful.layout.suit.max, },
    ["10:xbmcremote"] = { position=10, key='x', exclusive=true, spawn='xterm -class xbmcremote -e python2 /usr/bin/xbmcremote -c --host xbmc.lan', screen=VGA, layout=awful.layout.suit.max, },
    --["10:xbmcremote"] = { position=10, key='x', exclusive=true, spawn='xterm -class xbmcremote -e bash /home/Jo/mygit/scripts/bin/kbshare', screen=VGA, layout=awful.layout.suit.max, },
}
clientbuttons=awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus=c; c:raise() end),
    awful.button({ "Mod1" }, 1, awful.mouse.client.move),
    awful.button({ "Mod1" }, 3, awful.mouse.client.resize))

shiftyapps = {
         { match = { "Chrome", "Chromium", "Midori", "Navigator", "Namoroka","Firefox"} , tag="3:web", nopopup=true} ,
         { match = { "Thunderbird", "Mail", "Msgcompose", "Evolution"} , tag="4:mail", nopopup=true } ,
         { match = { "Pidgin", "Skype", "gajim"} , tag="2:im", nopopup=true } ,
         { match = { "xterm", "urxvt", "Terminator"} , honorsizehints=false, slave=true, tag="1:term" } ,
         { match = { "Thunar", "pcmanfm", "xarchiver", "Squeeze", "File-roller", "Nautilus" }, tag="5:fs" } ,
         { match = { "Geany", "gvim" }, tag="6:edit" } ,
         { match = { "xbmcremote" }, tag="10:xbmcremote" } ,
         { match = { "Eclipse" }, tag="6:edit", nopopup=true } ,
         { match = { "MPlayer", "ario", "Audacious", "pragha", "mplayer2", "bino" }, tag="7:media" } ,
         { match = { "VirtualBox" }, tag="8:emu" } ,
         { match = { "xbmc.bin" }, tag="9:mediafs" } ,
         { match = { "" }, buttons= clientbuttons },
}

shiftydefaults = {
  layout=awful.layout.suit.floating,
  ncol=1,
  mwfact=0.60,
  floatBars=true,
  run=function(tag) naughty.notify({ text=tag.name }) end
}

function pushincorner()
    local sel=client.focus
    local geometry=sel:geometry()
    geometry['x']=0
    geometry['y']=0
    sel:geometry(geometry)
end

function movecursor(x, y)
    local location = mouse.coords()
    location.x = location.x + x
    location.y = location.y + y
    mouse.coords(location)
end

keybindings = awful.util.table.join(
    awful.key({ modkey2, "Control" }, "c", function () awful.util.spawn(terminal) end),
    awful.key({ }, "Print", function () awful.util.spawn(binhome .. "caputereimg.sh /home/Jo/Pictures/SS") end),
    awful.key({ modkey,           }, "F2", function () awful.util.spawn(binhome .. "musiccontrol PlayPause") end),
    awful.key({ modkey,           }, "c", function () awful.util.spawn_with_shell("xclip -o | xclip -i -selection clipboard") end),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn(binhome .. "musiccontrol Previous") end),
    awful.key({ modkey,           }, "F4", function () awful.util.spawn(binhome .. "musiccontrol Next") end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn(binhome .. "musiccontrol Next") end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn(binhome .. "musiccontrol PlayPause") end),
    awful.key({ }, "XF86Battery", function () awful.util.spawn("xautolock -locknow && sudo pm-suspend") end),
    awful.key({ modkey,           }, "F7", function () awful.util.spawn(binhome .. "xrandr.sh --auto") end),    awful.key({ modkey,           }, "x", xbmckeyhandler),
    awful.key({ modkey,           }, "e", function () awful.util.spawn("thunar") end),
    awful.key({ modkey, }, "l", function () awful.util.spawn("xautolock -locknow") 
                                            awful.util.spawn(binhome .. "musiccontrol Pause")
    end),
    awful.key({ modkey2, "Control" }, "s", function () awful.util.spawn("skype") end),
    awful.key({ modkey2, "Control" }, "m", function () awful.util.spawn("pidgin") end),
    awful.key({ modkey,    }, "c", pushincorner),
    awful.key({ modkey2, "Control" }, "k", function () awful.util.spawn("geany") end),
    -- Mouse cursor bindings
    awful.key({ "Mod3",  }, "Left", function () movecursor(-10,0) end),
    awful.key({ "Mod3",  }, "Right", function () movecursor(10,0) end),
    awful.key({ "Mod3",  }, "Up", function () movecursor(0,-10) end),
    awful.key({ "Mod3",  }, "Down", function () movecursor(0,10) end)
)

