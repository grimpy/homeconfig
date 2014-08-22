local awful = require("awful")
local beautiful = require("beautiful")
local freedesktop_utils = require("freedesktop.utils")
local xdg_menu = require("myrc.archmenu")

local io = io
local table = table
local awesome = awesome
local ipairs = ipairs
local os = os
local string = string
local mouse = mouse

module("myrc.mainmenu")

local env = {}

-- Reserved.
function init(enviroment)
    env = enviroment
end

-- Creates main menu
-- Note: Uses beautiful.icon_theme and beautiful.icon_theme_size
-- env - table with string constants - command line to different apps

function build()
    local terminal = (env.terminal or "urxvtc") .. " "
    local man = (env.man or "xterm -e man") .. " "
    local editor = (env.editor or "xterm -e " .. (os.getenv("EDITOR") or "vim")) .. " "
    local browser = (env.browser or "firefox") .. " "

    freedesktop_utils.terminal = terminal
    freedesktop_utils.icon_theme = "Tango"
    freedesktop_utils.icon_sizes = {beautiful.icon_theme_size}

    local shutdown_menu = {
        { "Logout", awesome.quit, freedesktop_utils.lookup_icon({ icon = 'gnome-logout' }) },
        { "Switch user", function () awful.util.spawn("/home/Jo/mygit/scripts/bin/switchuser") end, freedesktop_utils.lookup_icon({ icon = 'gtk-switch' }) },
        { "Reboot", function () awful.util.spawn("sudo systemctl reboot") end, freedesktop_utils.lookup_icon({ icon = 'gtk-refresh' }) },
        { "Suspend", function () awful.util.spawn("sudo systemctl suspend") end, freedesktop_utils.lookup_icon({ icon = 'xfsm-suspend' }) },
        { "Hibernate", function () awful.util.spawn("sudo systemctl hibernate") end, freedesktop_utils.lookup_icon({ icon = 'xfsm-hibernate' }) },
        { "Shutdown", function () awful.util.spawn("sudo systemctl poweroff") end, freedesktop_utils.lookup_icon({ icon = 'gtk-stop' }) },
    }

    local mymainmenu_items_head = {
        { "Terminal", terminal, freedesktop_utils.lookup_icon({icon = 'terminal'}) },
        { "Browser", browser, freedesktop_utils.lookup_icon({icon = 'browser'}) },
        {"", nil, nil} --separator
    }

    local mymainmenu_items_tail = {
        {"", nil, nil}, --separator
        { "Reload", awesome.restart, freedesktop_utils.lookup_icon({ icon = 'gtk-refresh' }) },
        { "Shutdown", shutdown_menu, freedesktop_utils.lookup_icon({ icon = 'gtk-stop' })}
    }

    local mymainmenu_items = {}
    for _, item in ipairs(mymainmenu_items_head) do table.insert(mymainmenu_items, item) end
    for _, item in ipairs(xdg_menu) do table.insert(mymainmenu_items, item) end
    for _, item in ipairs(mymainmenu_items_tail) do table.insert(mymainmenu_items, item) end

    return awful.menu.new({ items = mymainmenu_items,
        keys = {up='k', down = 'j', back = 'h', exec = 'l'}})
end
