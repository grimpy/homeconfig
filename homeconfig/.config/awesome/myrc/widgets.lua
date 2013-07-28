local cal = require("cal")
local vicious = require('vicious')
local awful = require('awful')
local wibox = require('wibox')
local dbus = dbus
local io = { open = io.open, popen = io.popen}
local string = {find = string.find, match = string.match, format=string.format}

vicious.contrib = require("vicious.contrib")

module("myrc.widgets")

w = {}

function dbusCallBack(bus, iface, callback)
    dbus.add_match(bus, "interface='" .. iface .. "'")
    dbus.connect_signal(iface, callback)
end


local myip = wibox.widget.textbox()

function updateIP()
    local f = io.popen("ip r")
    local ipr = f:read("*all")
    f:close()
    local gwdev = string.match(ipr, 'default via .- dev (.-) metric')
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
end

updateIP()
dbusCallBack("system", "name.marples.roy.dhcpcd", updateIP)
w[#w+1] = myip

local mynet = wibox.widget.textbox()
mynet:set_font("Monospace 8")
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
        return '<span color="' .. color  ..  '">' .. tmp  .. "°C</span>"
    end
    , 2, {"coretemp.0", "core"})
w[#w+1] = mytemp


local mybat = wibox.widget.textbox()
function updateBat()
    local res = vicious.widgets.bat(nil, "BAT0")
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
w[#w+1] = mybat

local mymem = awful.widget.progressbar()
mymem:set_width(6)
mymem:set_vertical(true)
mymem:set_background_color("#494B4F")
mymem:set_border_color(nil)
mymem:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, 
                    {1, "#FF5656"}}})
vicious.register(mymem, vicious.widgets.mem, "$1", 13)
w[#w+1] = mymem


local mycpu = awful.widget.graph()
mycpu:set_width(50)
mycpu:set_background_color("#494B4F")
mycpu:set_color({ type = "linear", from = { 0, 0 }, to = { 0,10 }, stops = { {0, "#FF0000"}, {2, "#33FF00"}, {10, "#00FF00" }}})
vicious.register(mycpu, vicious.widgets.cpu, "$1")
w[#w+1] = mycpu

local myvol = awful.widget.progressbar()
myvol:set_width(6)
myvol:set_vertical(true)
myvol:set_background_color("#494B4F")
myvol:set_border_color(nil)
myvol:set_color("#0080FF")
vicious.register(myvol, vicious.widgets.volume, "$1", 2, "Master")
w[#w+1] = myvol

local mycal = awful.widget.textclock("%a %d/%m - %R")
cal.register(mycal)
w[#w+1] = mycal

