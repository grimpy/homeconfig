local inspect = require("inspect")
local ipairs = ipairs
local io = io

module("mylogger")

-- mylogger.logfile = '/dev/stdout'
function log(...)
    for i,v in ipairs({...}) do
        io.stderr:write(inspect(v) .. " ")
    end
    io.stderr:write("\n")
end

