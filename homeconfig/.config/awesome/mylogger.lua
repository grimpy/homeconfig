local inspect = require("inspect")
local ipairs = ipairs
local mylogger = {}

-- mylogger.logfile = '/dev/stdout'
function mylogger.log(...)
    for i,v in ipairs({...}) do
        io.stderr:write(inspect(v) .. " ")
    end
    io.stderr:write("\n")
end

return mylogger
