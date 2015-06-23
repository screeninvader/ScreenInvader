#!/lounge/bin/janosh -f

local util = require("util")

local function getPeerflixServerPid() 
  return tonumber(Janosh:capture("netstat -anp | sed -n 's/.*0[.]0[.]0[.]0:9000 .* \\([0-9]*\\)\\/node/\\1/p'"))
end

Janosh:subscribe("peerflixStart", function()
  pid=getPeerflixServerPid()
  
  if pid  == nil then
    Janosh:system("peerflix-server")    
  end
end)

Janosh:subscribe("peerflixStop", function() 
  pid=getPeerflixServerPid()
  if pid ~= nil then
    Janosh:system("kill " .. pid)
  end
end)

while true do
  Janosh:sleep(1000000)
end
