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
  Janosh:system("killall mupdf-x11; mupdf-x11 \"" .. file .. "\" &")
end

function MupdfClass.close(self)
  print("close")
  Janosh:system("killall mupdf-x11")
end

function MupdfClass.pageDown(self) 
  Janosh:keyType("Page_Down")
end

function MupdfClass.pageUp(self)
  Janosh:keyType("Page_Up")
end

function MupdfClass.scrollDown(self)
  Janosh:keyType("j")
end

function MupdfClass.scrollUp(self)
  Janosh:keyType("k")
end

function MupdfClass.scrollLeft(self)
  Janosh:keyType("h")
end

function MupdfClass.scrollRight(self)
  Janosh:keyType("l")
end

function MupdfClass.zoomIn(self)
  Janosh:keyType("plus")
end

function MupdfClass.zoomOut(self)
  Janosh:keyType("minus")
end

function MupdfClass.run(self) 
  while true do
    Janosh:sleep(10000)
  end
end

return MupdfClass:new()
