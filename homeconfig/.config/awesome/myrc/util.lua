local awful = require("awful")
local mylogger = require("mylogger")
local table = table
local tonumber = tonumber
local ipairs = ipairs
local capi = {
    client = client,
    tag = tag,
    screen = screen,
    button = button,
    mouse = mouse,
    root = root,
    timer = timer
}


module("myrc.util")

function getActiveTag()
    local scr
    if capi.client.focus then
        scr = capi.client.focus.screen
    else
        scr = capi.mouse.screen or 1
    end
    return awful.tag.selected(scr)
end

function resortTags()
    for scr = 1, capi.screen.count() do
        local tags = awful.tag.gettags(scr)
        table.sort(tags, function(a, b) 
            local ak = tonumber(a.name:match("([0-9]+):"))
            local bk = tonumber(b.name:match("([0-9]+):"))
            if ak and bk then
                return ak < bk
            else
                return a.name < b.name
            end
        end)
        for i, tag in ipairs(tags) do
            awful.tag.move(i, tag)
        end
    end

end
