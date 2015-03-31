#!/lounge/bin/janosh -f
local mplayer = require("mplayer")

local function split(str, delim)
    local res = {}
    local pattern = string.format("([^%s]+)%s", delim, delim)
    for line in str:gmatch(pattern) do
        table.insert(res, line)
    end
    return res
end

function openPlayer(key, op, value)
  print("open")
  obj=Janosh:get("/player/.")
  url=obj.url
  category=obj.category
  videoUrl=""
  title=""

  if category ~= "video" then
    output = Janosh:capture("/usr/bin/youtube-dl --encoding utf-8 -g -e \"" .. url .. "\"")
    print("split")
    lines = split(output, "\n")
    print(#lines)
    assert(#lines == 2)
    print("assign")
    title = lines[1]
    videoUrl = lines[2]
    videoUrl = string.gsub(videoUrl, "https://", "http://")
  else
    videoUrl = url
    title = basename(url)
  end
  mplayer:add(videoUrl, title, url)
end

Janosh:subscribe("/player/url", openPlayer)
Janosh:subscribe("playerPause", function(key,op,value) mplayer:pause() end)
Janosh:subscribe("playerStop", function(key,op,value) mplayer:stop() end)
Janosh:subscribe("playerNext", function(key,op,value) mplayer:next() end)
Janosh:subscribe("playerPrevious", function(key,op,value) mplayer:previous() end)
Janosh:subscribe("playerForward", function(key,op,value) mplayer:forward() end)
Janosh:subscribe("playerRewind", function(key,op,value) mplayer:rewind() end)
Janosh:subscribe("playerForwardMore", function(key,op,value) mplayer:forwardMore() end)
Janosh:subscribe("playerRewindMore", function(key,op,value) mplayer:rewindMore() end)
Janosh:subscribe("playerJump",  function(key,op,value) mplayer:jump(value) end)

mplayer:run()
