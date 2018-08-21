#!/lounge/bin/janosh -f

function refresh(key, op, value)
  Janosh:system("feh --bg-center /lounge/logo.png")
end

Janosh:subscribe("backgroundRefresh",  refresh)

Janosh:forever()

