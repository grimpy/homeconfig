local os = os
local pcall = pcall
local dofile = dofile
local awful = require('awful')

module("myrc.device")

function trim(s)
      -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local hostname = trim(awful.util.pread("hostname -s"))
local configdir = awful.util.getdir("config")
local devicepath = configdir .. "/devices/" .. hostname .. ".lua"
if not awful.util.file_readable(devicepath) then
    devicepath = configdir .. "/devices/default" 
end
success, device = pcall(function() return dofile(devicepath) end)
return device
