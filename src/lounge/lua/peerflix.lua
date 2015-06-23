#!/lounge/bin/janosh -f

local function getPeerflixServerPid() 
  return Janosh:capture("netstat -anp | sed 's/.*0[.]0[.]0[.]0:9000 .* \([0-9]*\)\/node/\1/p'")
end

Janosh:subscribe("peerflixStart", function()
  if string.match(getPeerflixServerPid(), "[0-9]*") == nil then
    Janosh:system("peeflix-server")    
  end
end)

Janosh:subscribe("peerflixStop", function() 
  pid=getPeerflixServerPid()
  if string.match(pid, "[0-9]*") ~= nil then
    Janosh:system("kill " .. pid)
  end
end)

while true do
  Janosh:sleep(1000000)
end
