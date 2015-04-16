#!/lounge/bin/janosh -f

-- takes two floats nomalized from 0 to 1
function move(key, op, value)
  pos = JSON:decode(value)
  Janosh:mouseMove(tonumber(pos[1]), tonumber(pos[2]))
end

-- takes two ints (screen coordinates) and moves the mouse pointer relative.
function moveRel(key,op,value)
  pos = JSON:decode(value)
  Janosh:mouseMoveRel(tonumber(pos[1]), tonumber(pos[2]))
end

-- 1=left, 2=middle, 3=right, 4=wheelup, 5=wheeldown
function down(key,op,value) 
  button = tonumber(value)
  -- avoid x11 error with assert
  assert(button > 0 and button < 6)
  Janosh:mouseDown(button)
end

function up(key,op,value)
  button = tonumber(value)
  -- avoid x11 error with assert
  assert(button > 0 and button < 6)
  Janosh:mouseUp(button)
end

Janosh:subscribe("mouseMoveAbs",  move)
Janosh:subscribe("mouseMoveRel", moveRel)
Janosh:subscribe("mouseUp",  up)
Janosh:subscribe("mouseDown",  down)

while true do
  Janosh:sleep(1000000)
end
