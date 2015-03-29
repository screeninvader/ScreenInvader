#!/lounge/bin/janosh -f

function notify(key, op, value)
  Janosh:system("notify-send " .. value)
end

Janosh:subscribe("notifySend",  notify)

while true do
  Janosh:sleep(1000000)
end


