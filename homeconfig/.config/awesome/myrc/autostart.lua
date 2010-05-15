local ipairs = ipairs
local awful = require("awful")
local utils = require("freedesktop.utils")
module("myrc.autostart")

function init(startdir)
    for i, program in ipairs(utils.parse_desktop_files({dir = startdir} )) do
        if program.cmdline then
            awful.util.spawn_with_shell(program.cmdline)
        end
    end
end
