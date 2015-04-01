#!/lounge/bin/janosh -f

local UtilClass = {}
UtilClass.__index = UtilClass

function UtilClass.new()
  return setmetatable({}, UtilClass)
end

function UtilClass.trim(self, s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function UtilClass.notify(self,msg)
  Janosh:publish("notifySend","W",msg)
end

function UtilClass.getWindowID(self,name)
  pid,sin,sout,serr = Janosh:popen("wmctrl", "-lx")
print(pid, sin, sout, serr)
  line = Janosh:preadLine(serr)
  if line ~= nil then return -1 end
  id=-1
  while true do 
    line = Janosh:preadLine(sout)
    if line == nil then break end
    tokens = self:split(line," ")
    assert(#tokens > 2)
    if tokens[3] == name then
      id = tonumber(tokens[1], 16)
    end
  end

  Janosh:pclose(sin)
  Janosh:pclose(sout)
  Janosh:pclose(serr)

  return id;
end

function UtilClass.split(self, str, delim)
    local res = {}
    local pattern = string.format("([^%s]+)%s", delim, delim)
    for line in str:gmatch(pattern) do
        table.insert(res, line)
    end
    return res
end

return UtilClass:new()


