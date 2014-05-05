local cal = require("cal")
local vicious = require('vicious')
local awful = require('awful')
local wibox = require('wibox')
local dbus = dbus
local os = os
local timer = timer
local io = { open = io.open, popen = io.popen}
local string = {find = string.find, match = string.match, format=string.format}

local device = require("myrc.device")
vicious.contrib = require("vicious.contrib")

module("myrc.widgets")

w = {}

function dbusCallBack(bus, iface, callback)
    dbus.add_match(bus, "interface='" .. iface .. "'")
    dbus.connect_signal(iface, callback)
end


local myip = wibox.widget.textbox()
myip:set_font(device.font)

local iptooltip = awful.tooltip({})
iptooltip:add_to_object(myip)

function updateIP()
    local f = io.popen("ip r")
    local ipr = f:read("*all")
    f:close()
    local gwdev = string.match(ipr, 'default via .- dev (.-) ')
    if not gwdev then
        myip:set_text("No GW")
        return
    end
    f = io.popen("ip a s " .. gwdev)
    local ipa = f:read("*all")
    f:close()
    local ip = string.match(ipa, "inet (.-)/")
    if not ip then
        myip:set_text("No IP")
        return
    end
    myip:set_text(ip)
    -- local f = io.popen("wpa_cli status | grep '^ssid' | cut -f2 -d=")
    local f = io.popen("iwconfig " .. gwdev)
    local iw = f:read("*all")
    f:close()
    iptooltip:set_markup(string.format("<span font_desc='%s'>%s</span>", device.font, iw))
end

updateIP()
dbusCallBack("system", "name.marples.roy.dhcpcd", updateIP)
w[#w+1] = myip

myip:buttons(awful.util.table.join(
    awful.button({}, 1, updateIP),
    awful.button({}, 3, function() awful.util.spawn("wpa_gui") end)
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
        local down = data["{total down_".. diunit .. "}"]
        local up = data["{total up_".. uiunit  .. "}"]
        local result = '<span color="#00FF00">%5s %s</span> <span color="#FF0000">%5s %s</span>'
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
        return string.format('<span color="%s">%s°C</span>', color, tmp)
    end
    , 2, {"coretemp.0", "core"})
w[#w+1] = mytemp


local mybat = wibox.widget.textbox()
mybat:set_font(device.font)
function updateBat()
    local res = vicious.widgets.bat(nil, device.battery)
    local per = res[2]
    local output = res[1] .. res[2]
    local color
    if res[1] ~= "-" then
        color = "#0080ff"
    else
        if per > 40 then
            color = "#00FF00"
        elseif per > 15 then
            color = "#ff9c00"
        else
            color = "#FF0000"
        end
    end
    output = '<span color="' .. color  ..  '">' .. output  .. "</span>"
    mybat:set_markup(output)
end
updateBat()
dbusCallBack("system", "org.freedesktop.UPower.Device", updateBat)
tm = timer({timeout=60})
tm:connect_signal("timeout", updateBat)
tm:start()

w[#w+1] = mybat

local mymem = awful.widget.progressbar()
mymem:set_width(6)
mymem:set_vertical(true)
mymem:set_background_color("#494B4F")
mymem:set_border_color(nil)
mymem:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, 
                    {1, "#FF5656"}}})

local memtooltip = awful.tooltip({})
memtooltip:add_to_object(mymem)
vicious.register(mymem, vicious.widgets.mem, function(widget, data) 
    memtooltip:set_markup(string.format("<span font_desc='%s'>%s%%</span>", device.font, data[1]))
    return data[1]
    end
    , 13)
w[#w+1] = mymem


local mycpu = awful.widget.graph()
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

local mycal = awful.widget.textclock("%a %d/%m - %R")
mycal:set_font(device.font)
cal.register(mycal)
w[#w+1] = mycal

function increasevolume()
    awful.util.spawn("amixer -M set " .. device.amixer .. " 5%+")
    updatevol()
end

function decreasevolume()
    awful.util.spawn("amixer -M set " .. device.amixer .. " 5%-")
    updatevol()
end

function mutevolume()
    awful.util.spawn("amixer -M set " .. device.amixer .. " toggle")
    updatevol()
end

myvoltext:buttons(awful.util.table.join(
    awful.button({}, 1, updatevol),
    awful.button({}, 3, mutevolume),
    awful.button({}, 4, increasevolume),
    awful.button({}, 5, decreasevolume)
))

keybindings = awful.util.table.join(
    awful.key({}, "XF86AudioLowerVolume", decreasevolume),
    awful.key({"Mod4"}, "Down", decreasevolume),
    awful.key({}, "XF86AudioRaiseVolume", increasevolume),
    awful.key({"Mod4"}, "Up", increasevolume),
    awful.key({}, "XF86AudioMute", mutevolume),
    awful.key({"Mod4"}, "0", mutevolume)
)
