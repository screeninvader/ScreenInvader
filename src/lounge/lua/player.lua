#!/lounge/bin/janosh -f
local mplayer = require("mplayer")

function open()
  obj=Janosh:get("/player/.")
  url=obj.url
  category=obj.category
  videoUrl=""
  title=""

  if category ~= "video" then
    ypid, ystdin, ystdout, ystderr = Janosh:popen("/usr/bin/youtube-dl","--encoding", "utf-8", "-g", "-e", url)
    title = Janosh:preadLine(ystdout)
    videoUrl = Janosh:preadLine(ystdout)
    videoUrl = string.gsub(videoUrl, "https://", "http://")
  else
    videoUrl = url
    title = basename(url)
  end
  mplayer:add(videoUrl, title, url)
end

Janosh:subscribe("/player/url", open)
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
