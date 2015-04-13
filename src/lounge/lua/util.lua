#!/lounge/bin/janosh -f

local UtilClass = {}
UtilClass.__index = UtilClass

function UtilClass.new()
  return setmetatable({}, UtilClass)
end

function UtilClass.hex_to_char(self, x)
  return string.char(tonumber(x, 16))
end

function UtilClass.urldecode(self, url)
  return url:gsub("%%(%x%x)", self.hex_to_char)
end

function UtilClass.http_get(self,url)
   return Janosh:capture("/usr/bin/curl -s -L '" .. url .. "'")
end

function UtilClass.getIPAddress(self) 
  return self:trim(Janosh:capture("/sbin/ifconfig eth0 | grep -Po 'inet addr:\\K.*?(?= )' | tail -n1"
))
end

function UtilClass.trim(self, s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function UtilClass.notify(self,msg)
  Janosh:publish("notifySend","W",msg)
end

function UtilClass.notifyLong(self,msg)
  Janosh:publish("notifyLong","W",msg)
end

function UtilClass.exception(self,msg)
  Janosh:publish("notifyException", "W", msg)
end

function UtilClass.getWindowID(self,name)
  pid,sin,sout,serr = Janosh:popen("wmctrl", "-lx")
  line = Janosh:preadLine(serr)
  if line ~= nil then
    print("Error:", line)
    return -1
  end
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
  Janosh:pwait(pid)
  return id;
end

function UtilClass.split(self,inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end
return UtilClass:new()


