#!/lounge/bin/janosh -f

Janosh:setenv("DISPLAY",":0")

local MidoriClass = {} -- the table representing the class, which will double as the metatable for the instances
MidoriClass.__index = MidoriClass -- failed table lookups on the instances should fallback to the class table, to get methods

function MidoriClass.new()
  return setmetatable({}, MidoriClass)
end

function MidoriClass.cmd(self, cmdstring) 
  print("cmd:", cmdstring)
  Janosh:system("midori -e " .. cmdstring)
end

function MidoriClass.openUrl(self, url)
  print("openUrl:", url)
  Janosh:system("midori " .. url .. "&")
  self:cmd("TabCloseOther")
  Janosh:system("xdotool windowraise $(xdotool getactivewindow)")
end

function MidoriClass.close(self)
  print("close")
  self:openUrl("http://localhost/blank.html")
  Janosh:system("xdotool windowminimize $(xdotool getactivewindow)")
end

function MidoriClass.pageDown(self) 
  Janosh:sytem("xdotool key Page_Down")
end

function MidoriClass.pageUp(self)
  Janosh:sytem("xdotool key Page_Up")
end

function MidoriClass.scrollDown(self)
  self:cmd("ScrollDown")
end

function MidoriClass.scollUp(self)
  self:cmd("ScrollUp")
end

function MidoriClass.zoomIn(self)
  self:cmd("ZoomIn")
end

function MidoriClass.zoomOut(self)
  self:cmd("ZoomOut")
end

function MidoriClass.run(self) 
  Janosh:system("xdotool windowminimize $(xdotool getactivewindow)")
  while true do
    Janosh:sleep(10000)
  end
end

return MidoriClass:new()
