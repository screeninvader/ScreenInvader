#!/lounge/bin/janosh -f

local util = require("util")

local function show() 
  print("show")
  Janosh:system("killall osd;/lounge/bin/osd -f  \"-misc-topaz a500a1000a2000-medium-r-normal--0-300-0-0-c-0-iso8859-1\" -t 0 " .. "http://" .. util:getIPAddress() .. " &")
end

local function hide()
  print("hide")
  Janosh:system("killall osd")
end

function toggle(key,op,value) 
  if value == "true" then
    hide()
  else
    show()
  end
end

show()

Janosh:subscribe("/player/active", toggle)
Janosh:subscribe("/browser/active", toggle)
Janosh:subscribe("/pdf/active", toggle)
Janosh:subscribe("/image/active", toggle)
Janosh:subscribe("/animation/active", toggle)

while true do 
  Janosh:sleep(100000)
end
