-- Standard awesome library
local awful = require("awful")
local wibox = require("wibox")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local shifty = require("shifty")
-- Custom
require("myrc.mainmenu")
require("myrc.autostart")
local cal = require("cal")
require("myrc.custom")
local bashets = require("bashets")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
home = os.getenv("HOME")
beautiful.init(home .. "/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = myrc.custom.terminal
browser = myrc.custom.browser
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
confdir = awful.util.getdir("config")

if myrc.custom.autostart then
    myrc.autostart.init(home .. "/.config/autostart/")
end

bashets.set_script_path("/dev/shm/bashets/scripts/")
bashets.set_temporary_path("/dev/shm/bashets/tmp/")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod3"
modkey2 = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- tag settings
shifty.config.tags = myrc.custom.shiftytags
shifty.config.apps = myrc.custom.shiftyapps

-- tag defaults
shifty.config.defaults = myrc.custom.shiftydefaults


-- {{{ XDG Menu
mymainmenu = myrc.mainmenu.build()
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- }}}
--
bashets.set_defaults({seperator=nil})

function bashetsUpdate(script, widget, format)
    script = bashets.util.fullpath(script)
    local data = bashets.util.readshell(script, nil)
    bashets.util.update_widget(widget, data, format)
end


mysep = wibox.widget.textbox()
mysep:set_text("  ")

mytemp = wibox.widget.textbox()
bashets.register("temp.sh", {widget=mytemp, update_time=2})

myip = wibox.widget.textbox()
bashetsUpdate("gwip.sh", myip, "$1")
bashets.register_d("system", "name.marples.roy.dhcpcd", nil, function() bashetsUpdate("gwip.sh", myip, "$1") end, "$1")

mybat = wibox.widget.textbox()
bashetsUpdate("bat.sh", mybat, "$1")
bashets.register_d("system", "org.freedesktop.UPower.Device", nil, function() bashetsUpdate("bat.sh", mybat, "$1") end, "$1")

myrx = wibox.widget.textbox()
bashets.register("net.sh 1 rx", {widget=myrx, update_time=1})

mytx = wibox.widget.textbox()
bashets.register("net.sh 1 tx", {widget=mytx, update_time=1})

-- Initialize widget
cpuwidget = awful.widget.graph()
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_max_value(100)  
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0,10 }, stops = { {0, "#FF0000"}, {2, "#33FF00"}, {10, "#00FF00" }}})
-- Register widget
bashets.register("cpu.sh", {widget=cpuwidget, update_time=2})
bashets.start()
-- Initialize widget
memwidget = awful.widget.progressbar()
memwidget:set_width(6)
memwidget:set_max_value(100)  
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, 
                    {1, "#FF5656"}}})
bashets.register("mem.sh", {widget=memwidget, update_time=2})

mixerw = awful.widget.progressbar()
mixerw:set_width(6)
mixerw:set_max_value(100)  
mixerw:set_vertical(true)
mixerw:set_background_color("#494B4F")
mixerw:set_border_color(nil)
mixerw:set_color("#0080FF")
bashets.register("vollevel.sh Master", {widget=mixerw, update_time=2})



-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock("%a %d/%m - %R")
cal.register(mytextclock)


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(myip)
    right_layout:add(mysep)
    right_layout:add(myrx)
    right_layout:add(mysep)
    right_layout:add(mytx)
    right_layout:add(mysep)
    right_layout:add(mybat)
    right_layout:add(mysep)
    right_layout:add(mytemp)
    right_layout:add(mysep)
    right_layout:add(memwidget)
    right_layout:add(mysep)
    right_layout:add(cpuwidget)
    right_layout:add(mysep)
    right_layout:add(mixerw)
    right_layout:add(mysep)

    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "p",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "n",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    
    -- Shifty: keybindings specific to shifty
    awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
    awful.key({modkey,        }, "o",
              function()
                  local t = client.focus:tags()[1]
                  local s = awful.util.cycle(screen.count(), awful.tag.getscreen(t) + 1)
                  awful.tag.history.restore()
                  t = shifty.tagtoscr(s, t)
                  awful.tag.viewonly(t)
              end),
    awful.key({modkey}, "a", shifty.add), -- creat a new tag
    awful.key({modkey, "Shift"}, "r", shifty.rename), -- rename a tag
    awful.key({modkey, "Shift"}, "a", -- nopopup new tag
    function()
        shifty.add({nopopup = true})
    end),

    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey, "Shift"   }, "h",
        function ()
            awful.client.swap.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "l",
        function ()
            awful.client.swap.bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "k",
        function ()
            awful.client.swap.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "j",
        function ()
            awful.client.swap.bydirection("down")
            if client.focus then client.focus:raise() end
        end),




    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey2,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    myrc.custom.keybindings,
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    --~ awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift"   }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Compute the maximum number of digit we need, limited to 9
-- for i = 1, (shifty.config.maxtags or 9) do
for _, shiftag in pairs(shifty.config.tags) do
    local i = shiftag.position
    local key = shiftag.key or i
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, key, function()
            local scr = shiftag.screen
            if client.focus.screen ~= scr then
                awful.screen.focus(scr)
            end
            local tag = shifty.getpos(i)
            local t =  awful.tag.viewonly(tag)
            scr = awful.tag.getscreen(tag)
            if scr ~= client.focus.screen then
                awful.screen.focus(scr)
            end
        end),
        awful.key({modkey, "Control"}, key, function()
            local t = shifty.getpos(i)
            t.selected = not t.selected
        end),
        awful.key({modkey, "Control", "Shift"}, key, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
        end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, key, function()
            if client.focus then
                t = shifty.getpos(i)
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
            end
        end))


end

-- Set keys
root.keys(globalkeys)
-- }}}

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
