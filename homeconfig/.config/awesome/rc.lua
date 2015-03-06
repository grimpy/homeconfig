-- Standard awesome library
local keydoc = require("keydoc")
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local tyrannical = require("tyrannical")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Custom
local menubar = require("menubar")
require("myrc.autostart")
require("myrc.custom")
require("myrc.util")
require("myrc.widgets")
local mylogger = require("mylogger")

tyrannical.tags = myrc.custom.tags 
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

local home = os.getenv("HOME")
if myrc.custom.autostart then
    myrc.autostart.init(home .. "/.config/autostart/")
end

confdir = awful.util.getdir("config")
beautiful.init(confdir .. "/theme.lua")

-- Default capskey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
capskey = "Mod3"
altkey = "Mod1"

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

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}


-- {{{ Menu Bar
menubar.utils.terminal = myrc.custom.terminal -- Set the terminal for applications that require it
mylauncher = awful.widget.button({ image = beautiful.awesome_icon })
mylauncher:buttons(awful.util.table.join(
    awful.button({}, 1, function () menubar.show() end)
    )
)

-- }}}

-- Menubar configuration
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ capskey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ capskey }, 3, awful.client.toggletag),
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
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
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

mysep = wibox.widget.textbox()
mysep:set_text("  ")

for s = 1, screen.count() do
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
    left_layout:add(myrc.widgets.myprompt)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    for _, widget in pairs(myrc.widgets.w) do
        right_layout:add(widget)
        right_layout:add(mysep)
    end

    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () menubar.show() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
keydoc.group("Clients")
globalkeys = awful.util.table.join(
    awful.key({ capskey,           }, "p",   awful.tag.viewprev, "Goto previous tag"       ),
    awful.key({ capskey,           }, "n",  awful.tag.viewnext, "Goto next tag"       ),
    awful.key({ capskey,           }, "Escape", awful.tag.history.restore),
    keydoc.group("Clients Focus"),
    awful.key({ capskey,           }, "h",
        function ()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end, "Right "),
    awful.key({ capskey,           }, "l",
        function ()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end, "Right"),
    awful.key({ capskey,           }, "k",
        function ()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end, "Up"),
    awful.key({ capskey,           }, "j",
        function ()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end, "Down"),
    -- Layout manipulation
    awful.key({ altkey,           }, "Tab",
        function ()
            if client.focus then
                awful.client.focus.byidx(1)
                client.focus:raise()
            end
        end, "Cycle"),
    keydoc.group("Clients Swap Location"),
    awful.key({ capskey, "Shift"   }, "h",
        function ()
            awful.client.swap.bydirection("left")
            if client.focus then client.focus:raise() end
        end, "Left"),
    awful.key({ capskey, "Shift"   }, "l",
        function ()
            awful.client.swap.bydirection("right")
            if client.focus then client.focus:raise() end
        end, "Right"),
    awful.key({ capskey, "Shift"   }, "k",
        function ()
            awful.client.swap.bydirection("up")
            if client.focus then client.focus:raise() end
        end, "Up"),
    awful.key({ capskey, "Shift"   }, "j",
        function ()
            awful.client.swap.bydirection("down")
            if client.focus then client.focus:raise() end
        end, "Down"),

    awful.key({ capskey,           }, "w", function () menubar.show() end),

    -- Standard program
    myrc.custom.keybindings,
    myrc.widgets.keybindings,

    -- awful.key({ capskey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    -- awful.key({ capskey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    -- awful.key({ capskey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    -- awful.key({ capskey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    -- awful.key({ capskey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    -- awful.key({ capskey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ capskey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ capskey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ capskey, "Control" }, "n", awful.client.restore)
)


clientkeys = awful.util.table.join(
    awful.key({ capskey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ capskey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ capskey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ capskey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ capskey, "Shift"   }, "o",      awful.client.movetoscreen                        ),
    awful.key({ capskey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),
    awful.key({ capskey,           }, "a",
        function (c)
            local t = shifty.add()
            c:tags({t})
        end)
)



function getNextTag(tagcfg)
    function getInfo(tag)
        return {tag=tag, scr=awful.tag.getscreen(tag), idx=awful.tag.getproperty(tag, 'index')}
    end
    local cur = getInfo(myrc.util.getActiveTag())
    local scrcnt = screen.count()
    local tags = {}

    for i = 1, screen.count() do
        for idx, tag in ipairs(awful.tag.gettags(i)) do
            local keymatch = tag.name:match("([0-9]?):")
            if tag.name == tagcfg.name or tagcfg.key == keymatch then
                taginfo = getInfo(tag)
                tags[#tags+1] = taginfo
            end
        end
    end
    function score(tag)
        local score = 0
        -- same screen
        if tag.idx == cur.idx and tag.scr == cur.scr then
            return 999999999
        elseif tag.scr == cur.scr then
            if tag.idx > cur.idx then
                return tag.idx - cur.idx            
            else
                return 100 * (scrcnt + 1) + tag.idx
            end
        else
            return 100 * scrcnt + tag.idx
        end
    end
    function sorter(tag1, tag2)
        return score(tag1) < score(tag2)
    end
    table.sort(tags, sorter)
    if #tags >= 1 then
        return tags[1].tag
    else
        return
    end
end

for _, tagcfg in pairs(myrc.custom.tags) do
    if tagcfg.key then
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ capskey }, tagcfg.key,
                  function ()
                        local tag = getNextTag(tagcfg)
                        if tag then
                           awful.tag.viewonly(tag)
                        else
                            if tagcfg.launch then
                                awful.util.spawn(tagcfg.launch)
                            end
                        end
                        local scr = awful.tag.getscreen(tag)
                        if scr then
                            awful.screen.focus(scr)
                        end
                  end),
        -- Toggle tag.
        awful.key({ capskey, "Control" }, tagcfg.key,
                  function ()
                      local tag = getNextTag(tagcfg)
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ capskey, "Shift" }, tagcfg.key,
                  function ()
                      if client.focus then
                          local tag = getNextTag(tagcfg)
                          local curcl = client.focus
                          if tag then
                              awful.client.movetotag(tag)
                              awful.tag.viewonly(tag)
                              client.focus = curcl
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ capskey, "Control", "Shift" }, tagcfg.key,
                  function ()
                      if client.focus then
                          local tag = getNextTag(tagcfg)
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
   end
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ altkey }, 1, awful.mouse.client.move),
    awful.button({ altkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

awesome.connect_signal("spawn::completed", function() myrc.util.resortTags() end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
