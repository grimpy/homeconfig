local awful = require("awful")
local client = client
local gears = require("gears")
local awesome = awesome
local keygrabber = keygrabber
local screen = screen
local mouse = mouse
local naughty = require("naughty")
local ipairs = ipairs
local string = string
local os = os
local io = io
local widgets = require("myrc.widgets")
local runonce = require("myrc.runonce")
local mylogger = require('mylogger')
local myrc = {}
local lockreplaceid = nil
myrc.util = require("myrc.util")
local asyncspawn = myrc.util.asyncspawn

module("myrc.custom")

browser = "browser"
terminal = "terminal"
autostart = true
winkey = "Mod4"
altkey = "Mod1"
capskey = "Mod4"
VGA = screen.count()
LCD = 1

runonce.run("dex -as ~/.config/autostart")

function removeFile(file)
    local f = io.open(file,"r")
    if f then
        os.remove(file)
        f:close()
    end
end

tags = {
    {
        name        = "1: Term",                 -- Call the tag "Term"
        key         = "F1",
        init        = true,                   -- Load the tag on startup
        launch      = "terminal",
        max_clients = 4,
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal", "Termite"}
    },
    {
        name        = "2: IM",                 -- Call the tag "Term"
        key         = "F2",
        launch      = "telegram-desktop",
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        init        = false,                   -- Load the tag on startup
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.fair.horizontal, -- Use the tile layout
        class       = {"Pidgin", "Skype", "gajim", 'TelegramDesktop'}
    },
    {
        name        = "3: Web",                 -- Call the tag "Term"
        key         = "F3",
        launch      = "browser",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.max, -- Use the tile layout
        class       = {"Chrome", "Google-chrome-stable", "Chromium", "Midori", "Navigator",
                       "Namoroka","Firefox", "Vivaldi-stable"}
    },
    {
        name        = "4: Mail",                 -- Call the tag "Term"
        key         = "F4",
        launch      = "emailclient",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"Thunderbird", "Mail", "Msgcompose", "Evolution", "openwmail"}
    },
    {
        name        = "5: FS",                 -- Call the tag "Term"
        key         = "F5",
        launch      = "pcmanfm",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.float, -- Use the tile layout
        class       = {"Thunar", "spacefm", "pcmanfm", "xarchiver", "Squeeze", "File-roller", "Nautilus"}
    },
    {
        name        = "6: Edit",                 -- Call the tag "Term"
        key         = "F6",
        launch      = "atom",
        init        = false,                   -- Load the tag on startup
        exclusive   = false,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.max, -- Use the tile layout
        class       = {"jetbrains-pycharm-ce", "Geany", "gvim", "Firebug", "sun-awt-X11-XFramePeer", "Devtools", "jetbrains-android-studio", "sun-awt-X11-XDialogPeer", "Atom", "code - insiders"}
    },
    {
        name        = "7: Media",                 -- Call the tag "Term"
        key         = "F7",
        launch      = "ario",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.float, -- Use the tile layout
        class       = {"MPlayer", "ario", "Audacious", "pragha", "mplayer2", "bino", "mpv", "Spotify"}
    },
    {
        name        = "8: Emu",                 -- Call the tag "Term"
        key         = "F8",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"VirtualBox", "Insomnia"}
    },
    {
        name        = "9: Mediafs",                 -- Call the tag "Term"
        key         = "F9",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"xbmc.bin", "Kodi", "zoom"}
    },
    {
        name        = "10:Remote",                 -- Call the tag "Term"
        key         = "x",
        launch      = "xterm -class xbmcremote -e python2 /usr/bin/kodiremote -c",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"xbmcremote"}
    },
    {
        name        = "0:",                 -- Call the tag "Term"
        key         = "0",
        init        = false,                   -- Load the tag on startup
        fallback    = true,
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile -- Use the tile layout
    }
}

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ altkey }, 1, awful.mouse.client.move),
    awful.button({ altkey }, 3, awful.mouse.client.resize))

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
    awful.spawn("xlock force")
end

function locktoggle()
    local res = awful.util.pread("xlock toggle")
    local color = "#0080ff"
    if res == "DISABLED\n" then
        color = "FF0000"
    else
        color = "00FF00"
    end
    local fg= "FFFFFF"
    local notification = naughty.notify({title="Lock status", text="", fg=fg, bg=color, replaces_id=lockreplaceid})
    lockreplaceid = notification.id
end

function suspend()
    lock()
    awful.spawn("systemctl suspend")
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
        local stop = false
        for _, key in ipairs(keys) do
            if key.key == pkey then
                stop = not key.callback()
            end
        end
        if pkey == 'Escape' or stop  then
            stop = true
            keygrabber.stop()
        end
        if noti and stop then
            naughty.destroy(noti)
        end
    end)
end

local shutdownkeys = { {key="s", help="for suspend", callback=suspend},
                       {key="r", help="for reboot", callback=asyncspawn("systemctl reboot")},
                       {key="e", help="for logout", callback=awesome.quit},
                       {key="c", help="for reload", callback=awesome.restart},
                       {key="p", help="for poweroff", callback=asyncspawn("systemctl poweroff")},
                       {key="l", help="for lock", callback=lock}
                    }
local mousekeys = { {key="Up", help="Move Mouse Up", callback=function () movecursor(0, -20); return true end},
                    {key="Down", help="Move Mouse Down", callback=function () movecursor(0, 20); return true end},
                    {key="Left", help="Move Mouse Left", callback=function () movecursor(-20, 0); return true end},
                    {key="Right", help="Move Mosue Right", callback=function () movecursor(20, 0); return true end},
                    {key="Delete", help="Left Click", callback=function () awful.spawn('xdotool click 1') end},
                    {key="End", help="Middle Click", callback=function () awful.spawn('xdotool click 2') end},
                    {key="Next", help="Right Click", callback=function () awful.spawn('xdotool click 3'); return true end}
                  }
local rofimenu = {
    {key="r", help="Run command", callback=asyncspawn("rofi -show run")},
    {key="s", help="Snippets", callback=asyncspawn("rofi -modi 'Snippets:rofisnippets' -show Snippets")},
    {key="c", help="Clipboard", callback=asyncspawn("roficlip")},
    {key="p", help="Randr", callback=asyncspawn("rofi -modi 'Randr:rofirandr' -show Randr")},
    {key="m", help="Math", callback=asyncspawn("rofi -modi 'MathExpr:mathexpr' -show MathExpr")},
    {key="k", help="Kill Process", callback=asyncspawn("rofi -modi 'Process:processkill' -show Process")},
    {key="w", help="Windows Select", callback=asyncspawn("rofi -show window")}
}

local audiomenu = {
    {key="t", help="Toggle headset mode", callback=asyncspawn("bluehead toggle")},
    {key="m", help="Toggle headset mute", callback=asyncspawn("bluehead mictoggle")},
    {key="r", help="Reconnect headset", callback=asyncspawn("btreconnect")},
    {key="-", help="Volume down", callback=asyncspawn("mediakeys -l 114")},
    {key="+", help="Volume up", callback=asyncspawn("mediakeys -l 115")},
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

function rename_tag()
    awful.prompt.run({ prompt = "Enter new tag:" },
    widgets.myprompt,
    function(new_name)
       if not new_name or #new_name == 0 then
          return
       else
          local screen = mouse.screen
          local tag = awful.tag.selected(screen)
          if tag then
             tag.name = new_name
          end
       end
    end)
end

function newtag()
    awful.prompt.run({ prompt = "Enter tag name:" },
    widgets.myprompt,
    function(new_name)
       if not new_name or #new_name == 0 then
          return
       else
          local screen = mouse.screen
          awful.tag.new({new_name}, screen)
       end
    end)
end

function movetagtoscreen()
    if client.focus then
        local t = client.focus:tags()[1]
        local s = awful.util.cycle(screen.count(), awful.tag.getscreen(t) + 1)
        awful.tag.history.restore()
        if not s or s < 1 or s > screen.count() then return end
        awful.tag.setscreen(t, s)
        awful.tag.viewonly(t)
    end
end


function movetagmenu()
    local keys = { {key="Left", help="Move Left", callback=function () movetag(-1); return true; end},
                   {key="Right", help="Move Right", callback=function () movetag(1); return true end}
                 }
    for i=1, 9 do
        keys[#keys+1] = {key=string.format("%s", i), help=string.format("Move to position %s", i), callback=function () movetag(0, i) end}

    end
    keymenu(keys, "Move Tag", {})

end

function xbmcmote()
    function togglekb()
        local output = awful.util.pread("xbmcmote kb")
        naughty.notify({title="Remote Keyboard", timeout=5, text=output})
    end
    local keys = { {key="r", help="Toggle Remote", callback=togglekb},
                   {key="x", help="Switch VT", callback=asyncspawn("xbmcmote x")},
                   {key="s", help="Sleep", callback=asyncspawn("xbmcmote s")},
                   {key="w", help="Wakeup", callback=asyncspawn("xbmcmote w")}
                 }
    keymenu(keys, "XBMCMote", {})
end

local tagkeys = { {key="n", help="New", callback=newtag},
                  {key="r", help="Rename", callback=rename_tag},
                  {key="m", help="Move", callback=movetagmenu},
                  {key="s", help="Move to Screen", callback=movetagtoscreen},
                  {key="d", help="Delete", callback=function ()
                    local t = awful.tag.selected()
                    awful.tag.delete(t)
                  end}
                }

keybindings = awful.util.table.join(
    awful.key({ altkey, "Control" }, "c", function () awful.spawn(terminal) end, {description="Open Terminal", group="launcher"}),
    awful.key({ }, "Print", function () awful.spawn("caputereimg.sh /home/Jo/Pictures/SS") end, {description="Take Screenshot", group="launcher"}),
    awful.key({ winkey,           }, "o", function () awful.spawn("rotatescreen") end, {description="Rotate Screen", group="screen"}),
    awful.key({ }, "XF86Battery", suspend, {description="Suspend", group="launcher"}),
    awful.key({ capskey}, "v", myrc.util.resortTags, {description="Resort Tags", group="launcher"}),
    awful.key({  }, "Caps_Lock", function() awful.spawn("fixkeyboard") end, {description="Reset Keyboard mods", group="launcher"}),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 10") end, {description="Brightness +", group="screen"}),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 10") end, {description="Brightness -", group="screen"}),
    awful.key({ winkey, }, "l", locktoggle, {description="Toggle Autolock", group="lock"}),
    awful.key({ winkey,           }, "p", function () awful.spawn( "xrandr.sh --auto") end, {description="Dual/Single Toggle", group="screen"}),
    awful.key({ winkey}, "s", function() keymenu(shutdownkeys, "Shutdown", {bg="#ff3333", fg="#ffffff"}) end, {description="Shutdown Menu", group="menus"}),
    awful.key({ winkey}, "e", function() keymenu(mousekeys, "Mouse Movement") end, {description="Mouse Movement", group="menus"}),
    awful.key({ capskey}, "t", function() keymenu(tagkeys, "Tag Management", {}) end, {description="Tag Management", group="menus"}),
    awful.key({ capskey}, "r", function() keymenu(rofimenu, "Rofi Menu", {}) end, {description="Rofi Menu", group="menus"}),
    awful.key({ capskey}, "a", function() keymenu(audiomenu, "Audio Menu", {}) end, {description="Audio Menu", group="menus"}),
    awful.key({ capskey,  }, "z", xbmcmote, {description="Kodi Menu", group="menus"}),
    awful.key({ capskey,           }, "u", function ()
        awful.client.urgent.jumpto()
        removeFile('/tmp/scrolllock')
    end, {description="Jump to urgent", group="tag"}),
    awful.key({ winkey }, "d", awful.tag.viewnone, {description="Show desktop", group="tag"})
)


client.connect_signal("property::urgent", function(c)
    local window = nil
    if client.focus then
        window = client.focus.window
    end
    if c.urgent and c.window ~= window then
        awful.spawn("scrolllock")
    elseif not awful.client.urgent.get() then
        removeFile('/tmp/scrolllock')
    end
end)
