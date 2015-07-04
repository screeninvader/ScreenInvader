#!/lounge/bin/janosh -f

local util = require("util")

local function getPeerflixServerPid()
  return tonumber(Janosh:capture("netstat -anp | sed -n 's/.*0[.]0[.]0[.]0:9000 .* \\([0-9]*\\)\\/node/\\1/p'"))
end

Janosh:subscribe("peerflixStop",function(key, op, value) 
  pid=getPeerflixServerPid()

  if pid ~= nil then
    Janosh:system("kill " .. pid)
  end
  
  Janosh:set_t("/peerflix/active","false")
end)

Janosh:subscribe("peerflixStart",function(key,op,value)
  pid=getPeerflixServerPid()

  if pid == nil then
    Janosh:system("peerflix-server &")
  end

  Janosh:set_t("/peerflix/active","true")
end)

Janosh:subscribe("peerflixAdd", function(key, op, value) 
  Janosh:system("curl -H 'Content-Type: application/json' --data '{\"link\":\"" .. value .. "\"}' http://localhost:9000/torrents")
end)

Janosh:publish("peerflixStart", "W", "")

while true do
  Janosh:sleep(1000000)
end
