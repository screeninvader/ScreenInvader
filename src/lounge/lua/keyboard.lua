#!/lounge/bin/janosh -f

function press(key, op, value)
  k = JSON:decode(value)
  print(k.pressed)
  Janosh:system("xdotool key " .. k.pressed)
end

Janosh:subscribe("keyPress",  press)

while true do
  Janosh:sleep(1000000)
end
