#!/lounge/bin/janosh -f

function move(key, op, value)
  pos = JSON:decode(value)
  Janosh:system("xdotool mousemove " .. pos.x .. " " .. pos.y)
end

function down(key,op,value) 
  Janosh:system("xdotool mousedown 1")
end

function up(key,op,value)
  Janosh:system("xdotool mouseup 1")
end

Janosh:subscribe("mouseMove",  move)
Janosh:subscribe("mouseUp",  up)
Janosh:subscribe("mouseDown",  down)

while true do
  Janosh:sleep(1000000)
end
