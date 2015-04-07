#!/lounge/bin/janosh -f

local util=require("util")
function fix(key, op, value)
  Janosh:transaction(function() 
    idx = tonumber(value) - 1
    src = Janosh:get("/playlist/items/#" .. idx .. "/source").items[1].source
    title = Janosh:get("/playlist/items/#" .. idx .. "/title").items[1].title
    util:notify("Fixing cached item:" .. title)

    output = Janosh:capture("/usr/bin/youtube-dl --encoding utf-8 -g -e \"" .. src .. "\"")
    lines = util:split(output, "\n")
    assert(#lines == 2)
    title = lines[1]
    videoUrl = lines[2]
    videoUrl = string.gsub(videoUrl, "https://", "http://")
    Janosh:set("/playlist/items/#" .. idx .. "/url", videoUrl)
  end)
  Janosh:publish("playerJump","W", idx + 1)
end

Janosh:subscribe("cacheFix",  fix)

while true do
  Janosh:sleep(1000000)
end
