#!/lounge/bin/janosh -f


local util = require("util")
local mplayer = require("mplayer")
local helpers = require("helpers")

local function basename(str)
  local name = string.gsub(str, "(.*/)(.*)", "%2")
  return name
end

function openPlayer(key, op, value)
  print("open")
  obj=Janosh:get("/player/.")
  url=obj.url
  category=obj.category
  videoUrl=""
  title=""

  if category ~= "video" and category ~= "audio" then
    items = helpers:resolve(url,category)

    for title, videoUrl in pairs(items) do
      print("ADD:", title)
      mplayer:add(videoUrl, title, url)
    end
  else
    videoUrl = url
    title = basename(url)
    mplayer:add(videoUrl, title, url)
  end
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
Janosh:subscribe("playerLoadFile", function(key,op,value) mplayer:loadFile(value) end)
Janosh:subscribe("playerCommand", function(key,op,value) mplayer:cmd(value) end)
Janosh:subscribe("playerSeek", function(key,op,value) mplayer:seek(value) end)

mplayer:run()
