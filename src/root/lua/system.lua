#!/lounge/bin/janosh -f


local function makeInittab(key,op,value)
  Janosh:system("/root/shell/system makeInittab")
end

Janosh:subscribe("systemMakeinittab", makeInittab)

while true do
  Janosh:sleep(100000)
end

