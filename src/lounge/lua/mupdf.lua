#!/lounge/bin/janosh -f

local util = require("util")

Janosh:set("/pdf/active", "false")

local MupdfClass = {} -- the table representing the class, which will double as the metatable for the instances
MupdfClass.__index = MupdfClass -- failed table lookups on the instances should fallback to the class table, to get methods

function MupdfClass.new()
  return setmetatable({}, MupdfClass)
end

function MupdfClass.openFile(self, file)
  util:notify("Open PDF: " .. file)

  print("openFile:", file)
  Janosh:system("killall mupdf; mupdf \"" .. file .. "\" &")
end

function MupdfClass.close(self)
  print("close")
  Janosh:system("killall mupdf")
end

function MupdfClass.pageDown(self) 
  Janosh:system("xdotool key Page_Down")
end

function MupdfClass.pageUp(self)
  Janosh:system("xdotool key Page_Up")
end

function MupdfClass.scrollDown(self)
  Janosh:system("xdotool key j")
end

function MupdfClass.scrollUp(self)
  Janosh:system("xdotool key k")
end

function MupdfClass.scrollLeft(self)
  Janosh:system("xdotool key h")
end

function MupdfClass.scrollRight(self)
  Janosh:system("xdotool key l")
end

function MupdfClass.zoomIn(self)
  Janosh:system("xdotool key plus")
end

function MupdfClass.zoomOut(self)
  Janosh:system("xdotool key minus")
end

function MupdfClass.run(self) 
  while true do
    Janosh:sleep(10000)
  end
end

return MupdfClass:new()
