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

winkey = "Mod4"
altkey = "Mod1"
capskey = "Mod4"
altgrkey = "Mod5"

function getActiveTag()
    local scr
    if capi.client.focus then
        scr = capi.client.focus.screen
    else
        scr = capi.mouse.screen or 1
    end
    return scr.selected_tag
end

function resortTags()
    for s in capi.screen do
        local tags = s.tags
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
            tag.index = i
            if #tag:clients() == 0 then
                tag:delete()
            end
        end
    end

end

function asyncspawn(cmd)
    function spawn()
        awful.spawn(cmd)
    end
    return spawn
end
