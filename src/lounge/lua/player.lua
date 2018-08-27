#!/lounge/bin/janosh -f


local util = require("util")
local mpv = require("mpv")
local helpers = require("helpers")

local function basename(str)
  local name = string.gsub(str, "(.*/)(.*)", "%2")
  return name
end

function open(key, op, value)
Janosh:transaction(function()
  obj=Janosh:get("/player/.")
  Janosh:tprint(obj)
  url=obj.url
  category=obj.category
  videoUrl=""
  title=""
   
  if category ~= "video" and category ~= "audio" then
    items = helpers:resolve(url,category)
    for title, videoUrl in pairs(items) do
      mpv:add(videoUrl, title, url, category)
      Janosh:publish("historyAdd", "W", JSON:encode({url=url, title=title}))
    end
  else
    videoUrl = url
    title = basename(url)
    mpv:add(videoUrl, title, url, category)
    Janosh:publish("historyAdd", "W", JSON:encode({url=url, title=title}))
  end
end)
end

Janosh:subscribe("/player/url", open)
Janosh:subscribe("playerPause", function(key,op,value) mpv:pause() end)
Janosh:subscribe("playerPlay", function(key,op,value) mpv:play() end)
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
