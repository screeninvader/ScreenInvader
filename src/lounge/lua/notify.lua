#!/lounge/bin/janosh -f

Janosh:system("dunst -fn \"-misc-topaz a500a1000a2000-medium-r-normal--0-240-0-0-c-0-iso8859-1\" -lto 3 -cto 1 -nto 1 &")

function send(key, op, value)
  Janosh:system("notify-send \"" .. value .. "\"")
end

function long(key, op, value)
  Janosh:system("notify-send -u low \"" .. value .. "\"")
end

function exception(key, op, value)
  Janosh:system("notify-send -u critical \"" .. value .. "\"")
end

Janosh:subscribe("notifySend",  send)
Janosh:subscribe("notifyLong", long)
Janosh:subscribe("notifyException", exception)

while true do
  print("sleep")
  Janosh:sleep(1000000)
end
