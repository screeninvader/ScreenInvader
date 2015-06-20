#!/lounge/bin/janosh -f

Janosh:subscribe("peerflixStart", function(key, op, value)
  Janosh:system("killall peerflix; peerflix -r -p 9999 \"" .. value .. "\" &")
end)

Janosh:subscribe("peerflixStop", function()
  Janosh:system("killall peerflix");
end)

while true do
  Janosh:sleep(1000000)
end


