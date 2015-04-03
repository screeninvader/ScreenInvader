#!/lounge/bin/janosh -f


local function setResolution(key,op,value)
  Janosh:system("/root/shell/display setResolution " .. Janosh:get("/display/adapter/value").adapter.value .. " " .. value)
end

local function setBlanking(key,op,value) 
  Janosh:system("/root/shell/display setBlanking " .. value)
end

function reload(key,op,value)
  Janosh:transaction(function()
    p,i,o,e = Janosh:popen("/root/shell/display", "readAvailableAdapters")
    j=0
    while true do
      line = Janosh:preadLine(o)
      if line == nil then break end
      if j == 0 then
        Janosh:set("/display/adapter/value",line)
      end
      Janosh:set("/display/adapter/choices/#" .. j, line)
      j = j + 1
    end
    Janosh:pclose(i)
    Janosh:pclose(o)
    Janosh:pclose(e)

    p,i,o,e = Janosh:popen("/root/shell/display", "readAvailableResolutions")
    j=0
    while true do
      line = Janosh:preadLine(o)
      if line == nil then break end
      Janosh:set("/display/resolution/choices/#" .. j, line)
      j = j + 1
    end
    Janosh:pclose(i)
    Janosh:pclose(o)
    Janosh:pclose(e)

    p,i,o,e = Janosh:popen("/root/shell/display", "readCurrentResolution")
    j=0
    line = Janosh:preadLine(o)
    assert(line ~= nil)
    Janosh:set("/display/resolution/value", line)
    Janosh:pclose(i)
    Janosh:pclose(o)
    Janosh:pclose(e)

  end)
end

Janosh:subscribe("/display/resolution/value", setResolution)
Janosh:subscribe("/display/blank/value", setBlanking)
Janosh:subscribe("displayReload", reload)

while true do
  Janosh:sleep(100000)
end

