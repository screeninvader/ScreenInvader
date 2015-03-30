#!/lounge/bin/janosh -f

Janosh:system("dunst -fn \"-misc-topaz a500a1000a2000-medium-r-normal--0-240-0-0-c-0-iso8859-1\" -to 1 &")

function notify(key, op, value)
  print("notify")
  Janosh:system("notify-send \"" .. value .. "\"")
end

Janosh:subscribe("notifySend",  notify)

while true do
  print("sleep")
  Janosh:sleep(1000000)
end
