local ipairs = ipairs
local awful = require("awful")
local utils = require("freedesktop.utils")
local r = require("myrc.runonce")

module("myrc.autostart")

function init(startdir)
    if r.shallExecute() then
        for i, program in ipairs(utils.parse_desktop_files({dir = startdir} )) do
            if program.cmdline then
                r.run(program.cmdline)
            end
        end
    end
end
