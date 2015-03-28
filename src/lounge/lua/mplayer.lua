#!/lounge/bin/janosh -f

local RUN_DIR="/var/run/mplayer"
local CMD_FIFO=RUN_DIR .. "/cmdfifo"
Janosh:exec({
  "mkdir -p " .. RUN_DIR,
  "rm -rf " .. CMD_FIFO,
  "mkfifo " .. CMD_FIFO
})
Janosh:setenv("DISPLAY",":0")
Janosh:setenv("http_proxy","http://localhost:1234/")
local PID, STDIN, STDOUT, STDERR = Janosh:popen("/usr/bin/mplayer","-idle", "-input", "file=\"/dev/stdin\"")
Janosh:setenv("http_proxy","")

function basename(str)
  local name = string.gsub(str, "(.*/)(.*)", "%2")
  return name
end

local MplayerClass = {} -- the table representing the class, which will double as the metatable for the instances
MplayerClass.__index = MplayerClass -- failed table lookups on the instances should fallback to the class table, to get methods

function MplayerClass.new()
  return setmetatable({}, MplayerClass)
end

function MplayerClass.jump(self, idx) 
    obj = Janosh:get("/playlist/items/.")
    if tonumber(idx) > #obj then
      idx = #obj
    end
    file = obj[tonumber(idx)].url
    self:cmd("pause")
    Janosh:trigger("/player/active", "true")
    self:cmd("loadfile " .. file)
    Janosh:trigger("/playlist/index", idx)
end

function MplayerClass.enqueue(self, videoUrl, title, srcUrl) 
  if title == "" then
    title = "(no title)"
  end
  size = Janosh:size("/playlist/items/.")
  Janosh:mkobj("/playlist/items/#" .. size .. "/.")
  Janosh:set("/playlist/items/#" .. size .. "/url", videoUrl)
  Janosh:set("/playlist/items/#" .. size .. "/title", title)
  Janosh:set("/playlist/items/#" .. size .. "/source", srcUrl)
end

function MplayerClass.add(self, videoUrl, title, srcUrl)
  self:enqueue(videoUrl, title, srcUrl)

  Janosh:trigger("/notify/message", "Playing " .. title)
  if Janosh:get("/player/active").player.active == "false" then
    self:jump(10000000) -- jump to the ned of the playlist
  end
end

function MplayerClass.run(self) 
  SOTRACK="DEMUXER: ==> Found"
  EOTRACK="GLOBAL: EOF code: 1"
  PATH_CHANGED="GLOBAL: ANS_path="
  CACHEEMPTY="Cache empty"

  while true do
    line=""
    logf = io.open("/var/log/mplayer.log", "w")
print("output")
    while true do
      line = Janosh:preadLine(STDOUT)
      if line == nil then break end 
      logf:write(line .. "\n")
      logf:flush()
      if string.find(line, EOTRACK) then
        self:eotrack()
      elseif string.find(line, SOTRACK) then
        self:sotrack()
      elseif string.find(line, CACHEEMPTY) then
        self:cache_empty()
      end
    end
    --:close()
    Janosh:sleep(1000)
  end
end

function MplayerClass.cmd(self, cmdstring) 
 Janosh:lock("MplayerClass.cmd")
 print(Janosh:fwrite(STDIN, cmdstring .. "\n"))
 Janosh:unlock("MplayerClass.cmd")
end

function MplayerClass.setVolume(self, vol) 
  self:cmd("volume " .. vol .. " 1")
end

function MplayerClass.setMute(self, mute) 
  if mute == true then
    self:cmd("mute 1")
  else
    self:cmd("mute 0")
  end
end

function MplayerClass.forward(self) 
  self:cmd("seek +10")
end

function MplayerClass.forwardMore(self)
  self:cmd("seek +300")
end

function MplayerClass.rewind(self)
  self:cmd("seek -10")
end

function MplayerClass.rewindMore(self)
  self:cmd("seek -300")
end

function MplayerClass.pause(self)
  self:cmd("pause")
end

function MplayerClass.stop(self)
  self:cmd("pause")
  self:cmd("stop")
  Janosh:set("/player/active","false")
end

function MplayerClass.osd(self)
  self:cmd("osd")
end

function MplayerClass.subtitle(self)
  self:cmd("sub_visibility")
end

function MplayerClass.sotrack(self)
end

function MplayerClass.cache_empty(self)
  Janosh:trigger("/notify/message", "Network Problem!")
end

function MplayerClass.eotrack(self) 
print("eotrack")
  obj = Janosh:get("/playlist/.")
  idx = tonumber(obj.index)
  len = #obj.items
print("len: " .. len)
print("idx: " .. idx)
  if idx < len then
    self:jump(idx + 1)
  else
    Janosh:set("/player/active", "false")
    self:stop()
  end
end

return MplayerClass:new()