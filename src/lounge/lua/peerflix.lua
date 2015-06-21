#!/lounge/bin/janosh -f

local util = require("util")

Janosh:subscribe("peerflixStart", function(key, op, value)
  util:notify("Peerflix start")
  obj = JSON:decode(value)
  local PID, STDIN, STDOUT, STDERR = Janosh:popen("peerflix", "-r", "-p", "9999", obj.src)

  while true do
    line = Janosh:preadLine(MSTDERR)
    if line == nil then break end

    
  end
end)

Janosh:subscribe("peerflixStop", function(key, op, value)
  util:notify("Peerflix stop")
  Janosh:system("killall -9 peerflix");
end)

while true do
  Janosh:sleep(1000000)
end


