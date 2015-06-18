#!/lounge/bin/janosh -f

function add(key, operation, value)
  print("add")
  obj = JSON:decode(value)
  name = tostring(Janosh:epoch()) .. "-" .. obj.title;
  Janosh:system("echo \"" .. obj.url .. "\" > \"/ipns/local/" .. name .. "\"")
  print("Added " .. value)
end

Janosh:subscribe("historyAdd", add)
while true do
  Janosh:sleep(1000000) -- milliseconds
end

