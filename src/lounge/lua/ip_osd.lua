#!/lounge/bin/janosh -f

local util = require("util")

local function tprint(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

local function show() 
  print("show")
  Janosh:system("killall osd;/lounge/bin/osd -f  \"-misc-topaz a500a1000a2000-medium-r-normal--0-300-0-0-c-0-iso8859-1\" -t 0 " .. "http://" .. util:getIPAddress() .. " &")
end

local function hide()
  print("hide")
  Janosh:system("killall osd")
end

function toggle(key,op,value) 
  print("toggle")
  obj = Janosh:get("/player/active","/browser/active","/pdf/active","/image/active","/animation/active")
tprint(obj)
  if obj.player.active or  obj.browser.active or  obj.pdf.active or obj.image.active or  obj.animation.active then
    hide()
  else
    show()
  end
end

toggle()
show()

Janosh:subscribe("/player/active", toggle)
Janosh:subscribe("/browser/active", toggle)
Janosh:subscribe("/pdf/active", toggle)
Janosh:subscribe("/image/active", toggle)
Janosh:subscribe("/animation/active", toggle)

while true do 
  Janosh:sleep(100000)
end
