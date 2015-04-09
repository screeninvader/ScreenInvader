#!/lounge/bin/janosh -f


local util = require("util")
local mpv = require("mpv")
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
      mpv:add(videoUrl, title, url)
    end
  else
    videoUrl = url
    title = basename(url)
    mpv:add(videoUrl, title, url)
  end
end

Janosh:subscribe("/player/url", openPlayer)
Janosh:subscribe("playerPause", function(key,op,value) mpv:pause() end)
Janosh:subscribe("playerStop", function(key,op,value) mpv:stop() end)
Janosh:subscribe("playerNext", function(key,op,value) mpv:next() end)
Janosh:subscribe("playerPrevious", function(key,op,value) mpv:previous() end)
Janosh:subscribe("playerForward", function(key,op,value) mpv:forward() end)
Janosh:subscribe("playerRewind", function(key,op,value) mpv:rewind() end)
Janosh:subscribe("playerForwardMore", function(key,op,value) mpv:forwardMore() end)
Janosh:subscribe("playerRewindMore", function(key,op,value) mpv:rewindMore() end)
Janosh:subscribe("playerJump",  function(key,op,value) mpv:jump(value) end)
Janosh:subscribe("playerLoadFile", function(key,op,value) mpv:loadFile(value) end)
Janosh:subscribe("playerCommand", function(key,op,value) mpv:cmd(value) end)
Janosh:subscribe("playerSeek", function(key,op,value) mpv:seek(value) end)

mpv:run()
