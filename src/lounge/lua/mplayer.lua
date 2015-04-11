#!/lounge/bin/janosh -f

local util = require("util")

Janosh:set("/player/active", "false")
Janosh:set("/player/paused", "false")

--Janosh:setenv("VDPAU_OSD","1")
Janosh:setenv("http_proxy","http://localhost:1234/")
Janosh:system("killall mplayer")
local PID, STDIN, STDOUT, STDERR = Janosh:popen("bash", "-c", "exec mplayer -idle -input file=/dev/stdin 2>&1")
Janosh:pclose(STDERR)

--terminate mplayer and close loffile on exit
--Janosh:exitHandler(function(sig)
--  print("caught signal:", sig)
--  Janosh:kill(PID)
--  os.exit(1)
--end)

-- unset causes wierd errors
Janosh:setenv("http_proxy","")

local MplayerClass = {} -- the table representing the class, which will double as the metatable for the instances
MplayerClass.__index = MplayerClass -- failed table lookups on the instances should fallback to the class table, to get methods

function MplayerClass.new()
  return setmetatable({}, MplayerClass)
end

function MplayerClass.jump(self, idx) 
  print("jump:", idx)
  obj = Janosh:get("/playlist/items/.")
  if tonumber(idx) > #obj then
    idx = #obj
  end
  file = obj[tonumber(idx)].url
  title = obj[tonumber(idx)].title
  if string.match(file, "http[s]*://") then
    if string.match(file, "googlevideo.com") then
      target=file:gsub("http", "https")
    end

    Janosh:setenv("http_proxy","http://localhost:1234/")
    p, i, o, e = Janosh:popen("curl", "--head", target)
    Janosh:setenv("http_proxy","")
    line=""
    head=""
    while true do
      line=Janosh:preadLine(o)
      if line == nil then break end
      head= head .. string.gsub(line, "\r", "\n")
    end
    Janosh:pclose(i)
    Janosh:pclose(e)
    Janosh:pclose(o)

    line=util:split(head,"\n")[1]
    token=util:split(line," ")[2]
    code=tonumber(token)
   
    if code ~= 200 and code ~= 302 then
      Janosh:publish("cacheFix", "W", idx)
      print("INDEX:", idx)
      return
    end
  end

  self:cmd("pause")
  Janosh:set_t("/player/active", "true")
  util:notify("Loading: " .. title)
  self:cmd("loadfile " .. file)
  Janosh:set_t("/playlist/index", tostring(idx))
end

function MplayerClass.previous(self) 
  util:notify("previous")
  self:jump(tonumber(Janosh:get("/playlist/index").index) - 1)
end

function MplayerClass.next(self)
  util:notify("next")
  self:jump(tonumber(Janosh:get("/playlist/index").index) + 1)
end

function MplayerClass.seek(self, seconds)
  self:cmd("set_property time_pos " .. seconds)
end

function MplayerClass.enqueue(self, videoUrl, title, srcUrl) 
  util:notify("Queued: " .. title)
  if title == "" then
    title = "(no title)"
  end
  size = Janosh:size("/playlist/items/.")
  Janosh:mkobj("/playlist/items/#" .. size .. "/.")
  Janosh:set("/playlist/items/#" .. size .. "/url", videoUrl)
  Janosh:set("/playlist/items/#" .. size .. "/title", title)
  Janosh:set("/playlist/items/#" .. size .. "/source", srcUrl)
  print("enqueuend")
end

function MplayerClass.add(self, videoUrl, title, srcUrl)
  self:enqueue(videoUrl, title, srcUrl)

  if Janosh:get("/player/active").active == "false" then
    self:jump(10000000) -- jump to the ned of the playlist
  end
end

function MplayerClass.run(self) 
print("run")
  Janosh:thread(function()
    while true do
     Janosh:sleep(1000)
     Janosh:lock("MplayerClass.cmd")
     Janosh:pwrite(STDIN, "pausing_keep run \"echo TIMEPOS: ${time_pos}/${length}\" > /dev/stdout\n")
     Janosh:unlock("MplayerClass.cmd")
    end
  end)()

  SOTRACK="DEMUXER: ==> Found"
  EOTRACK="GLOBAL: EOF code: 1"
  PATH_CHANGED="GLOBAL: ANS_path="
  CACHEEMPTY="Cache empty"
  TIMEPOS="TIMEPOS: "

  while true do
    line=""
    while true do
      line = Janosh:preadLine(STDOUT)
      if line == nil then break end 
      print(line)
      if string.find(line, EOTRACK) then
        self:eotrack()
      elseif string.find(line, SOTRACK) then
        self:sotrack()
      elseif string.find(line, CACHEEMPTY) then
        self:cache_empty()
      elseif string.find(line, TIMEPOS) then
        times=util:split(line:gsub(TIMEPOS,""), "/")
        Janosh:publish("playerTimePos", "W", JSON:encode(times))
      end
    end
    Janosh:sleep(1000)
  end
end

function MplayerClass.cmd(self, cmdstring) 
 Janosh:lock("MplayerClass.cmd")
 print("cmd:", cmdstring)
 Janosh:pwrite(STDIN, cmdstring .. "\n")
 Janosh:unlock("MplayerClass.cmd")
end

function MplayerClass.forward(self) 
  util:notify("Forward")
  self:cmd("seek +10")
end

function MplayerClass.forwardMore(self)
  util:notify("Forward more")
  self:cmd("seek +300")
end

function MplayerClass.rewind(self)
  util:notify("Rewind")
  self:cmd("seek -10")
end

function MplayerClass.rewindMore(self)
  util:notify("Rewind more")
  self:cmd("seek -300")
end

function MplayerClass.pause(self)
  Janosh:transaction(function()
    util:notify("Pause")
    paused = Janosh:get("/player/paused").paused
    self:cmd("pause")
    if paused == "false" then
      Janosh:set_t("/player/paused", "true")
    else
      Janosh:set_t("/player/paused", "false")
    end
  end)
end

function MplayerClass.stop(self)
  util:notify("Stop")
  self:cmd("pause")
  self:cmd("stop")

  Janosh:transaction(function()
    if Janosh:get("/player/active").active == "true" then
      Janosh:set_t("/player/active","false")
      Janosh:publish("backgroundRefresh", "W", "")
    end
  end)
end

function MplayerClass.osd(self)
  self:cmd("osd")
end

function MplayerClass.subtitle(self)
  self:cmd("sub_visibility")
end

function MplayerClass.sotrack(self)
  Janosh:transaction(function()
    idx = Janosh:get("/playlist/index").index
    title = Janosh:get("/playlist/items/#" .. tonumber(idx - 1) .. "/title").items[1].title
    self:cmd("osd_show_property_text \"" .. title .. " ${length}\"  3000 0")
  end)
end

function MplayerClass.cache_empty(self)
  Janosh:publish("notifySend", "Network Problem!")
end

function MplayerClass.eotrack(self) 
  print("eotrack")
  obj = Janosh:get("/playlist/.")
  idx = tonumber(obj.index)
  len = #obj.items
print("idx: ", idx)
print("len: ", len)
  if idx < len then
    self:jump(tostring(idx + 1))
  else
    self:stop()
  end
end

function MplayerClass.loadFile(self,path)
  Janosh:set_t("/player/active", "true")
  self:cmd("loadfile " .. path)
end

return MplayerClass:new()
