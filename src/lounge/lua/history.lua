#!/lounge/bin/janosh -f

function add(key, operation, value)
  print("add")
  obj = JSON:decode(value)
  name = tostring(Janosh:epoch()) .. "-" .. obj.title;
  Janosh:system("echo \"" .. tostring(Janosh:epoch()) .. " " .. obj.url .. " " .. obj.title ..  "\" >> /media/history")
  print("Added " .. value)
end

Janosh:subscribe("historyAdd", add)

Janosh:forever()

