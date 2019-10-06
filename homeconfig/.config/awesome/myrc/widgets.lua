local vicious = require('vicious')
local awful = require('awful')
local util = require('awful.util')
local prompt = require('awful.prompt')
local theme = require("theme")
local gears = require("gears")
local ipairs = ipairs
local type = type
local completion = require('awful.completion')
local wibox = require('wibox')
local dbus = dbus
local os = os
local screen = screen
local io = { open = io.open, popen = io.popen, stderr= io.stderr}
local string = {find = string.find, match = string.match, format=string.format}
local device = require("myrc.device")
local util = require("myrc.util")
local asyncspawn = myrc.util.asyncspawn
vicious.contrib = require("vicious.contrib")

module("myrc.widgets")

local capskey = util.capskey
local winkey = util.winkey

w = {}

function dbusCallBack(bus, iface, callback)
    dbus.add_match(bus, "interface='" .. iface .. "'")
    dbus.connect_signal(iface, callback)
end

myprompt = wibox.widget.textbox()
myprompt:set_font(device.font)

function cmdprompt()
    prompt.run({ prompt = 'Run: ' }, myprompt,
                 function (...)
                      local result = util.spawn(...)
                      if type(result) == "string" then
                          promptbox.widget:set_text(result)
                      end
                  end,
                  completion.shell,
                  util.getdir("cache") .. "/history")
end

function completionwrapper(values)
    function wrapper(text, cur_pos, ncomp)
        return completion.generic(text, cur_pos, ncomp, values)
    end
    return wrapper
end

function runprompt()
    local mytags = {}
    local mytagnames = {}
    for s=1, screen.count() do
        for _, tag in ipairs(awful.tag.gettags(s)) do
            nr, name = tag.name:match("([^:]+):([^:]+)")
            if not name then
                name = tag.name
            end
            mytagnames[#mytagnames+1] = name
            mytags[name] = tag
        end
    end

    function result(...)
        awful.tag.viewonly(mytags[...])
    end
    prompt.run({prompt='Tag: '}, myprompt, result, completionwrapper(mytagnames), nil)
end


local myip = wibox.widget.textbox()
myip:set_font(device.font)

local iptooltip = awful.tooltip({})
iptooltip:add_to_object(myip)

function updateIP()
    local f = io.open('/sys/class/net/bond0/bonding/active_slave', "r")
    local t = f:read("*all")
    local neticon = ''
    if string.match(t, "wl.-") then
        neticon = ''
    end
    local f = io.popen("ip r")
    local ipr = f:read("*all")
    local ipinfo = ""
    f:close()
    local gwdev = string.match(ipr, 'default via .- dev (.-) ')
    if not gwdev then
        ipinfo = "No GW"
    else
        f = io.popen("ip a s " .. gwdev)
        local ipa = f:read("*all")
        f:close()
        local ip = string.match(ipa, "inet (.-)/")
        if not ip then
            ipinfo = "No IP"
        else
            ipinfo = ip
        end
    end

    myip:set_markup(string.format("<span color='#66C0FF'>%s %s</span>", neticon, ipinfo))
    local f = io.popen("iwconfig | grep -v 'no wireless'")
    local iw = f:read("*all")
    f:close()
    iptooltip:set_markup(string.format("<span  font_desc='%s'>%s</span>", device.font, iw))
end

updateIP()
dbusCallBack("system", "name.marples.roy.dhcpcd", updateIP)
w[#w+1] = myip


local netmenucfg = {
             {"Restart DHCP", asyncspawn("sudo systemctl restart dhcpcd"), },
             {"WiFi reconnect", asyncspawn("wifi reconnect"), },
             {"Enable Hotspot", switchap}
           }
local args = {}
args["items"] = netmenucfg
args["theme"] = theme
local netmenu = awful.menu.new(args)

myip:buttons(awful.util.table.join(
    awful.button({}, 1, updateIP),
    awful.button({}, 3, function()
        local apmode = string.match(awful.util.pread("wifi mode"), "(AP)") == "AP"
        local icon = ""
        if apmode then
            icon = "/usr/share/icons/AwOkenDark/clear/24x24/actions/dialog-yes.png"
        else
            icon = "/usr/share/icons/AwOkenDark/clear/24x24/actions/dialog-no.png"
        end

        function switchap()
            if not apmode then
                awful.util.spawn("wifi enableap")
            else
                awful.util.spawn("wifi enablewifi")
            end
        end
        netmenu:delete(3)
        netmenu:add({"Enable Hotspot", switchap, icon})
        netmenu:show()
    end)
))

local mynet = wibox.widget.textbox()
mynet:set_font(device.font)
vicious.register(mynet, vicious.contrib.net,
    function(widget, data)
        local uiunit = "kb"
        local diunit = 'kb'
        local dunit = "KiB"
        local uunit = 'KiB'
        if data['{total down_b}'] + 0 > 1024^2 then
           diunit = 'mb'
           dunit = 'MiB'
        end
        if data['{total up_b}'] + 0 > 1024^2 then
           uiunit = 'mb'
           uunit = 'MiB'
        end
        local down = data["{"..device.network.." down_".. diunit .. "}"]
        local up = data["{"..device.network.." up_".. uiunit  .. "}"]
        local result = '<span color="#00FF00">%5s %s</span> <span color="#FF0000">%5s %s</span>'
        return string.format(result, down, dunit, up, uunit)
    end

)
w[#w+1] = mynet

local mytemp = wibox.widget.textbox()
mytemp:set_font(device.font)
vicious.register(mytemp, vicious.widgets.thermal,
    function(widget, data)
        local tmp = data[1]
        local color
        if tmp < 70 then
            color = "#00FF00"
        elseif tmp < 85 then
            color = "#ff9c00"
        else
            color = "#FF0000"
        end
        return string.format(' <span color="%s">%s </span>', color, tmp)
    end
    , 2, {"thermal_zone0", "sys"})
w[#w+1] = mytemp


local mybat = wibox.widget.textbox()
mybat:set_font(device.font)
function updateBat()
    local res = vicious.widgets.bat(nil, device.battery)
    if not res then
        return
    end
    local per = res[2]
    local color
    local icon = "⚡"
    if res[1] == "+" then
        icon = ""
        color = "#0080ff"
    else
        icon = ""
        if per > 80 then
            icon = ""
            color = "#00FF00"
        elseif per > 60 then
            icon = ""
            color = "#00FF00"
        elseif per > 40 then
            icon = ""
            color = "#00FF00"
        elseif per > 20 then
            icon = ""
            color = "#ff9c00"
        else
            icon = ""
            color = "#FF0000"
        end
    end
    local output = icon .. res[2]
    output = '<span color="' .. color  ..  '">' .. output  .. "</span>"
    mybat:set_markup(output)
end
updateBat()
dbusCallBack("system", "org.freedesktop.UPower.Device", updateBat)
gears.timer {
    timeout=60,
    autostart=true,
    callback=updateBat
}

w[#w+1] = mybat

local mymem = wibox.widget {
    {
        max_value     = 1,
        value         = 0.75,
        widget        = wibox.widget.progressbar,
        background_color = "#494b4f",
        color = {type = "linear", from = {0, 0}, to = {10, 0}, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, {1, "#FF5656"} } }
    },
    forced_height = 100,
    forced_width  = 6,
    direction     = 'east',
    layout        = wibox.container.rotate,
}

local memtooltip = awful.tooltip({})
memtooltip:add_to_object(mymem)
vicious.register(mymem.widget, vicious.widgets.mem, function(widget, data)
    widget.value = data[1] / 100
    mymem.value = data[1] / 100
    memtooltip:set_markup(string.format("<span font_desc='%s'>%s%%</span>", device.font, data[1]))
    return data[1]
    end
    , 13)
w[#w+1] = mymem


local mycpu = wibox.widget.graph()
mycpu:set_width(50)
mycpu:set_background_color("#494B4F")
mycpu:set_color({ type = "linear", from = { 0, 0 }, to = { 0,10 }, stops = { {0, "#FF0000"}, {2, "#33FF00"}, {10, "#00FF00" }}})
vicious.register(mycpu, vicious.widgets.cpu, "$1")
w[#w+1] = mycpu

local myvoltext = wibox.widget.textbox()
function updatevol()
    local data = vicious.widgets.volume(nil, device.amixer)
    local color = {
        ["♫"]  = "yellow", -- "",
        ["♩"] = "red"  -- "M"
    }
    if data then
        myvoltext:set_markup(string.format("<span color='%s' font_desc='%s'>%3s%s</span>", color[data[2]], device.font, data[1], data[2]))
   end
end
updatevol()
w[#w+1] = myvoltext

local mycal = wibox.widget.textclock("%a %d/%m - %R")
mycal:set_font(device.font)
local month_calendar = awful.widget.calendar_popup.month({start_sunday=true, spacing=1})
month_calendar:attach(mycal, 'tr')
w[#w+1] = mycal

function increasevolume()
    awful.spawn("amixer -M set " .. device.amixer .. " 5%+")
    updatevol()
end

function decreasevolume()
    awful.spawn("amixer -M set " .. device.amixer .. " 5%-")
    updatevol()
end

function mutevolume()
    awful.spawn("amixer -M set " .. device.amixer .. " toggle")
    updatevol()
end

myvoltext:buttons(awful.util.table.join(
    awful.button({}, 1, updatevol),
    awful.button({'Shift'}, 1, asyncspawn('pavucontrol')),
    awful.button({}, 3, mutevolume),
    awful.button({}, 4, increasevolume),
    awful.button({}, 5, decreasevolume)
))

keybindings = awful.util.table.join(
    awful.key({winkey}, "Down", decreasevolume, {description="Descrease Volume", group="sound"}),
    awful.key({winkey}, "Up", increasevolume, {description="Increase Volume", group="sound"}),
    awful.key({winkey}, "0", mutevolume, {description="Mute Volume", group="sound"}),
    awful.key({capskey}, "y", runprompt, {description="Search Tag", group="tag"})
)
