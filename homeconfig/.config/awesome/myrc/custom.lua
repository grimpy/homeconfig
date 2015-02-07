local awful = require("awful")
local client = client
local awesome = awesome
local menubar = require("menubar")
local keygrabber = keygrabber
local screen = screen
local mouse = mouse
local naughty = require("naughty")
local ipairs = ipairs
local string = string
local os = os
local io = io
local widgets = require("myrc.widgets")
local myrc = {}
myrc.util = require("myrc.util")

module("myrc.custom")
binhome = os.getenv("HOME") .. "/mygit/scripts/bin/"
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications/", "/usr/local/share/applications", "~/.local/share/applications" }

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

tags = {
    {
        name        = "1:Term",                 -- Call the tag "Term"
        key         = "1",
        init        = false,                   -- Load the tag on startup
        launch      = "urxvt",
        max_clients = 4,
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"}
    },
    {
        name        = "2:IM",                 -- Call the tag "Term"
        key         = "2",
        launch      = "pidgin",
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        init        = false,                   -- Load the tag on startup
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.fair.horizontal, -- Use the tile layout
        class       = {"Pidgin", "Skype", "gajim"}
    },
    {
        name        = "3:Web",                 -- Call the tag "Term"
        key         = "3",
        launch      = "browser",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"Chrome", "Chromium", "Midori", "Navigator", "Namoroka","Firefox"}
    },
    {
        name        = "4:Mail",                 -- Call the tag "Term"
        key         = "4",
        launch      = "thunderbird",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"Thunderbird", "Mail", "Msgcompose", "Evolution"}
    },
    {
        name        = "5:FS",                 -- Call the tag "Term"
        key         = "5",
        launch      = "pcmanfm",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.float, -- Use the tile layout
        class       = {"Thunar", "pcmanfm", "xarchiver", "Squeeze", "File-roller", "Nautilus"}
    },
    {
        name        = "6:Edit",                 -- Call the tag "Term"
        key         = "6",
        launch      = "gvim",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"Geany", "gvim", "Firebug", "sun-awt-X11-XFramePeer", "Devtools", "jetbrains-android-studio"}
    },
    {
        name        = "7:Media",                 -- Call the tag "Term"
        key         = "7",
        launch      = "ario",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {LCD},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.float, -- Use the tile layout
        class       = {"MPlayer", "ario", "Audacious", "pragha", "mplayer2", "bino", "mpv"}
    },
    {
        name        = "8:Emu",                 -- Call the tag "Term"
        key         = "8",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"VirtualBox"}
    },
    {
        name        = "9:Mediafs",                 -- Call the tag "Term"
        key         = "9",
        init        = false,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {VGA},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"xbmc.bin", "Kodi"}
    },
    {
        name        = "10:Remote",                 -- Call the tag "Term"
        key         = "x",
        launch      = "xterm -class xbmcremote -e python2 /usr/bin/xbmcremote -c --host xbmc.lan",
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

clientbuttons=awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus=c; c:raise() end),
    awful.button({ "Mod1" }, 1, awful.mouse.client.move),
    awful.button({ "Mod1" }, 3, awful.mouse.client.resize))


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
    awful.util.spawn("xlock")
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
        local continue = false
        for _, key in ipairs(keys) do
            if key.key == pkey then 
                stopped = true
                keygrabber.stop()
                continue = key.callback()
            end
        end
        if not stopped then
            keygrabber.stop()
        end
        if noti then
            naughty.destroy(noti)
        end
        if continue then
            keymenu(keys, naughtytitle, naughtypreset)
        end
   end)
end

local shutdownkeys = { {key="s", help="for suspend", callback=suspend},
                       {key="r", help="for reboot", callback=function() awful.util.spawn("systemctl reboot") end},
                       {key="e", help="for logout", callback=awesome.quit},
                       {key="c", help="for reload", callback=awesome.restart},
                       {key="p", help="for poweroff", callback=function() awful.util.spawn("systemctl poweroff") end},
                       {key="l", help="for lock", callback=lock}
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
        local output = awful.util.pread(binhome .. "xbmcmote kb")
        naughty.notify({title="Remote Keyboard", timeout=5, text=output})
    end
    local keys = { {key="r", help="Toggle Remote", callback=togglekb},
                   {key="x", help="Switch VT", callback=function () awful.util.spawn(binhome .. "xbmcmote x") end},
                   {key="s", help="Sleep", callback=function () awful.util.spawn(binhome .. "xbmcmote s") end},
                   {key="w", help="Wakeup", callback=function () awful.util.spawn(binhome .. "xbmcmote w") end}
                 }
    keymenu(keys, "XBMCMote", {})
end

local tagkeys = { -- {key="a", help="Add", callback=shifty.add},
                  {key="r", help="Rename", callback=rename_tag},
                  {key="m", help="Move", callback=movetagmenu},
                  {key="d", help="Delete", callback=function () 
                    local t = awful.tag.selected() 
                    awful.tag.delete(t)
                  end}
                }

function tagtoscr(scr, t)
    -- break if called with an invalid screen number
    if not scr or scr < 1 or scr > screen.count() then return end
    -- tag to move
    local otag = t or awful.tag.selected()

    awful.tag.setscreen(otag, scr)
    -- set screen and then reset tag to order properly
    if #otag:clients() > 0 then
        for _ , c in ipairs(otag:clients()) do
            if not c.sticky then
                c.screen = scr
                c:tags({otag})
            else
                awful.client.toggletag(otag, c)
            end
        end
    end
    return otag
end


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
    awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn_with_shell("xbacklight -inc 10") end),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn_with_shell("xbacklight -dec 10") end),
    awful.key({ }, "XF86Battery", suspend),
    awful.key({ "Mod3"}, "v", myrc.util.resortTags),
    awful.key({ "Mod3"}, "s", function() keymenu(shutdownkeys, "Shutdown", {bg="#ff3333", fg="#ffffff"}) end),
    awful.key({ "Mod3"}, "t", function() keymenu(tagkeys, "Tag Management", {}) end),
    awful.key({ modkey }, "k", function() awful.util.spawn_with_shell("setxkbmap us,ar altgr-intl, ; xmodmap ~/.Xmodmap") end),
    awful.key({ modkey,           }, "p", function () awful.util.spawn(binhome .. "xrandr.sh --auto") end),
    awful.key({ modkey, "Shift" }, "l", function () awful.util.spawn("xautolock -disable") end),
    awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("xautolock -enable") end),
    awful.key({ "Mod3",           }, "u", function () 
        awful.client.urgent.jumpto()
        removeFile('/tmp/scrolllock')
    end),
    awful.key({"Mod3",        }, "o",
          function()
              if client.focus then
                  local t = client.focus:tags()[1]
                  local s = awful.util.cycle(screen.count(), awful.tag.getscreen(t) + 1)
                  awful.tag.history.restore()
                  t = tagtoscr(s, t)
                  awful.tag.viewonly(t)
              end
          end),
    awful.key({ modkey,    }, "c", pushincorner),
    awful.key({ "Mod3",  }, "t", tagmanagement),
    awful.key({ modkey }, "d", awful.tag.viewnone),

    -- Mouse cursor bindings
    awful.key({ "Mod3",  }, "Left", function () movecursor(-10,0) end),
    awful.key({ "Mod3",  }, "z", xbmcmote),
    awful.key({ "Mod3",  }, "Right", function () movecursor(10,0) end),
    awful.key({ "Mod3",  }, "Up", function () movecursor(0,-10) end),
    awful.key({ "Mod3",  }, "Down", function () movecursor(0,10) end)
)


client.connect_signal("property::urgent", function(c) 
    local window = nil
    if client.focus then
        window = client.focus.window
    end
    if c.urgent and c.window ~= window then
        awful.util.spawn(binhome .. "scrolllock")
    elseif not awful.client.urgent.get() then
        removeFile('/tmp/scrolllock')
    end
end)
