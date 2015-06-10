#!/lounge/bin/janosh -f

function add(key, operation, value)
  sum = Janosh:capture("echo \"" .. value .. "\" | md5sum");  
  name = tostring(Janosh:epoch()) .. "-" .. sum;
  Janosh:system("echo \"" .. value .. "\" > /ipns/local/" .. name)
  print("Added " .. value)
end

Janosh:subscribe("historyAdd", add)
while true do
  Janosh:sleep(1000000) -- milliseconds
end

