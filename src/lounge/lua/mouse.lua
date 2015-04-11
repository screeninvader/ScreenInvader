#!/lounge/bin/janosh -f

function move(key, op, value)
  pos = JSON:decode(value)
  print(pos[1])
  Janosh:mouseMove(tonumber(pos[1]), tonumber(pos[2]))
end

function down(key,op,value) 
  Janosh:mouseDown(tonumber(value))
end

function up(key,op,value)
  Janosh:mouseUp(tonumber(value))
end

Janosh:subscribe("mouseMove",  move)
Janosh:subscribe("mouseUp",  up)
Janosh:subscribe("mouseDown",  down)

while true do
  Janosh:sleep(1000000)
end
