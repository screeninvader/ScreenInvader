#!/lounge/bin/janosh -f

-- all values received here shoud be x11 keysymbols
function down(key,op,value) 
  Janosh:keyDown(value)
end

function up(key,op,value)
  Janosh:keyUp(value)
end

function type(key,op,value)
  Janosh:keyType(value)
end

Janosh:subscribe("keyUp",  up)
Janosh:subscribe("keyDown",  down)
Janosh:subscribe("keyType",  type)

while true do
  Janosh:sleep(1000000)
end
