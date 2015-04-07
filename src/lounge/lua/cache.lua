#!/lounge/bin/janosh -f

local util=require("util")
function fix(key, op, value)
  Janosh:transaction(function() 
    src = Janosh:get("/playlist/items/#" .. value .. "/source").items[1].source
    output = Janosh:capture("/usr/bin/youtube-dl --encoding utf-8 -g -e \"" .. src .. "\"")
    lines = util:split(output, "\n")
    assert(#lines == 2)
    title = lines[1]
    videoUrl = lines[2]
    videoUrl = string.gsub(videoUrl, "https://", "http://")
    Janosh:set("/playlist/items/#" .. value .. "/url", videoUrl)
  end)
end

Janosh:subscribe("cacheFix",  print)

while true do
  Janosh:sleep(1000000)
end
