#!/lounge/bin/janosh -f

local UtilClass = {}
UtilClass.__index = UtilClass

function UtilClass.new()
  return setmetatable({}, UtilClass)
end

function UtilClass.notify(self,msg)
  Janosh:publish("notifySend","W",msg)
end

return UtilClass:new()
