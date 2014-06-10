local awful = require("awful")
local client = client
local keygrabber = keygrabber
local screen = screen
local mouse = mouse
local naughty = require("naughty")
local shifty = require("shifty")
local ipairs = ipairs
local string = string
local os = os
local io = io

module("myrc.custom")
shifty.config.sloppy = false
binhome = os.getenv("HOME") .. "/mygit/scripts/bin/"

browser = binhome .. "browser"
terminal = "urxvtc"
autostart = true
modkey = "Mod4"
modkey2 = "Mod1"
VGA = screen.count()
LCD = 1


function removeFile(file)
    local f = io.open(file,"r")
    if f then
        os.remove(file)
        f:close()
    end
end

shiftytags = {
    ["1:term"] = { position=1, key=1, exclusive=true, max_clients=4, screen=VGA, spawn=terminal, layout=awful.layout.suit.fair.horizontal},
    ["2:im"] = { position=2, key=2, exclusive=true, spawn="pidgin", screen=VGA, layout=awful.layout.suit.fair.horizontal, },
    ["3:web"] = { position=3, key=3, exclusive=true, spawn=browser, screen=LCD, layout=awful.layout.suit.max, icon="/usr/share/icons/gnome/16x16/apps/web-browser.png"},
    ["4:mail"] = { position=4, key=4, exclusive=true, spawn="emailclient", layout=awful.layout.suit.max, screen=VGA},
    ["5:fs"] = { position=5, key=5, exclusive=true, spawn="pcmanfm", layout=awful.layout.suit.floating, screen=LCD},
    ["6:edit"] = { position=6, key=6, exclusive=true, spawn="gvim", screen=VGA, nopopup=true, layout=awful.layout.suit.max, },
    ["7:media"] = { position=7, key=7, exclusive=true, screen=LCD, nopopup=true, layout=awful.layout.suit.floating, },
    ["9:mediafs"] = { position=9, key=9, exclusive=true, screen=LCD, nopopup=true, layout=awful.layout.suit.max.fullscreen, },
    ["8:emu"] = { position=8, key=8, exclusive=true, spawn="VirtualBox", screen=LCD, nopopup=true, layout=awful.layout.suit.max, },
    ["10:xbmcremote"] = { position=10, key='x', exclusive=true, spawn='xterm -class xbmcremote -e python2 /usr/bin/xbmcremote -c --host xbmc.lan', screen=VGA, layout=awful.layout.suit.max, },
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
         { match = { "Geany", "gvim", "Firebug", "sun-awt-X11-XFramePeer", "Devtools", "jetbrains-android-studio" }, tag="6:edit" } ,
         { match = { "xbmcremote" }, tag="10:xbmcremote" } ,
         { match = { "Eclipse" }, tag="6:edit", nopopup=true } ,
         { match = { "MPlayer", "ario", "Audacious", "pragha", "mplayer2", "bino", "mpv" }, tag="7:media" } ,
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

function lock()
    awful.util.pread("xautolock -enable && sleep 0.5 && xautolock -locknow && sleep 0.5")
end

function suspend()
    lock()
    awful.util.spawn("systemctl suspend")
end

function keymenu(keys, naughtytitle, naughtypreset)
    local noti = nil
    if naughtytitle then
        naughtyprop = naughtypreset or {}
        if not naughtyprop.position then
            naughtyprop.position = 'top_left'
        end
        local txt = ''
        for _, key in ipairs(keys) do
            local descr = key.help or ""
            txt = txt .. "\nPress " .. key.key .. " " .. descr
        end
        noti = naughty.notify({title=naughtytitle, timeout=0, text=txt, preset=naughtyprop})
    end
    keygrabber.run(function(mod, pkey, event)
        if event == "release" then return end
        local stopped = false
        for _, key in ipairs(keys) do
            if key.key == pkey then 
                stopped = true
                keygrabber.stop()
                key.callback()
            end
        end
        if not stopped then
            keygrabber.stop()
        end
        if noti then
            naughty.destroy(noti)
        end
   end)
end

local shutdownkeys = { {key="s", help="for suspend", callback=suspend},
                       {key="r", help="for reboot", callback=function() awful.util.spawn("systemctl reboot") end},
                       {key="p", help="for poweroff", callback=function() awful.util.spawn("systemctl poweroff") end},
                       {key="l", help="for lock", callback=lock},
                     }

function movetag(offset, idx) 
    local screen=client.focus.screen
    local tag = awful.tag.selected(screen)
    local idx = idx or awful.tag.getidx(tag)
    idx = idx + offset
    if idx <= 0 then
        idx = 1
    end
    local nrtags = #awful.tag.gettags(screen)
    if idx > nrtags then
        idx = nrtags
    end
    awful.tag.move(idx, tag)
end

function movetagmenu()
    local keys = { {key="Left", help="Move Left", callback=function () movetag(-1) end},
                   {key="Right", help="Move Right", callback=function () movetag(1) end}
                 }
    for i=1, 9 do
        keys[#keys+1] = {key=string.format("%s", i), help=string.format("Move to position %s", i), callback=function () movetag(0, i) end}

    end
    keymenu(keys, "Move Tag", {})

end

local tagkeys = { {key="a", help="Add", callback=shifty.add},
                  {key="r", help="Rename", callback=shifty.rename},
                  {key="m", help="Move", callback=movetagmenu},
                  {key="d", help="Delete", callback=shifty.del}
                }



keybindings = awful.util.table.join(
    awful.key({ modkey2, "Control" }, "c", function () awful.util.spawn(terminal) end),
    awful.key({ }, "Print", function () awful.util.spawn(binhome .. "caputereimg.sh /home/Jo/Pictures/SS") end),
    awful.key({ modkey,           }, "o", function () awful.util.spawn(binhome .. "rotatescreen") end),
    awful.key({ modkey,           }, "F2", function () awful.util.spawn(binhome .. "musiccontrol PlayPause") end),
    awful.key({ modkey,           }, "c", function () awful.util.spawn_with_shell("xclip -o | xclip -i -selection clipboard") end),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn(binhome .. "musiccontrol Previous") end),
    awful.key({ modkey,           }, "F4", function () awful.util.spawn(binhome .. "musiccontrol Next") end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn(binhome .. "musiccontrol Next") end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn(binhome .. "musiccontrol PlayPause") end),
    awful.key({ }, "XF86Battery", suspend),
    awful.key({ "Mod3"}, "s", function() keymenu(shutdownkeys, "Shutdown", {bg="#ff3333", fg="#ffffff"}) end),
    awful.key({ "Mod3"}, "t", function() keymenu(tagkeys, "Tag Management", {}) end),
    awful.key({ modkey,           }, "p", function () awful.util.spawn(binhome .. "xrandr.sh --auto") end),
    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("xautolock -disable") end),
    awful.key({ modkey,    }, "c", pushincorner),
    -- Mouse cursor bindings
    awful.key({ "Mod3",  }, "Left", function () movecursor(-10,0) end),
    awful.key({ "Mod3",  }, "Right", function () movecursor(10,0) end),
    awful.key({ "Mod3",  }, "Up", function () movecursor(0,-10) end),
    awful.key({ "Mod3",  }, "Down", function () movecursor(0,10) end)
)

client.connect_signal("property::urgent", function(c) 
    if c.urgent and c.window ~= client.focus.window then
        awful.util.spawn(binhome .. "scrolllock")
    elseif not awful.client.urgent.get() then
        removeFile('/tmp/scrolllock')
    end
end)
