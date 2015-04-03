#!/lounge/bin/janosh -f

function refresh(key, op, value)
  Janosh:system("feh --bg-center /lounge/logo.png")
end

Janosh:subscribe("backgroundRefresh",  refresh)

while true do
  Janosh:sleep(1000000)
end
