#!/lounge/bin/janosh -f

function down(key,op,value) 
  Janosh:keyDown(value)
end

function up(key,op,value)
  Janosh:keyUp(value)
end

function press(key,op,value)
  Janosh:keyDown(value)
  Janosh:keyUp(value)
end

Janosh:subscribe("keyUp",  up)
Janosh:subscribe("keyDown",  down)
Janosh:subscribe("keyPress",  press)

while true do
  Janosh:sleep(1000000)
end
