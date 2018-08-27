#!/lounge/bin/janosh -f

local util = require("util")

Janosh:setenv("DISPLAY",":0")
local MidoriClass = {} -- the table representing the class, which will double as the metatable for the instances
MidoriClass.__index = MidoriClass -- failed table lookups on the instances should fallback to the class table, to get methods

function MidoriClass.new()
  return setmetatable({}, MidoriClass)
end

function MidoriClass.cmd(self, cmdstring) 
  print("cmd:", cmdstring)
--  Janosh:system("killall -0 midori && midori --plain -e " .. cmdstring)
end

function MidoriClass.minimize(self)
  xid = util:getWindowID("midori4.Midori")
  if xid ~= -1 then
  print("minimize:", xid)
  print("xdotool windowminimize " .. xid) 
   Janosh:system("xdotool windowminimize " .. xid)
  end
end

function MidoriClass.raise(self)
   xid = util:getWindowID("midori$.Midori")
  if xid ~= -1 then
    print("raise:", xid)
    Janosh:system("xdotool windowraise " .. xid) 
  end
end

function MidoriClass.openUrl(self, url)
  util:notify("Open Browser: " .. url)

  print("openUrl:", url)
  Janosh:system("killall midori")
  Janosh:system("midori --plain -e Location \"" .. url .. "\" &")
  --self:raise()
end

function MidoriClass.close(self)
  print("close")
  Janosh:system("killall midori")
--  self:minimize()
end

--function MidoriClass.pageDown(self) 
--  Janosh:keyType("Page_Down")
--end

--function MidoriClass.pageUp(self)
--  Janosh:keyType("Page_Up")
--end

function MidoriClass.scrollDown(self)
  self:cmd("ScrollDown")
end

function MidoriClass.scrollUp(self)
  self:cmd("ScrollUp")
end

function MidoriClass.scrollLeft(self)
  self:cmd("ScrollLeft")
end

function MidoriClass.scrollRight(self)
  self:cmd("ScrollRight")
end

function MidoriClass.zoomIn(self)
  self:cmd("ZoomIn")
end

function MidoriClass.zoomOut(self)
  self:cmd("ZoomOut")
end

function MidoriClass.run(self) 
  while true do
    Janosh:sleep(10000)
  end
end

return MidoriClass:new()
