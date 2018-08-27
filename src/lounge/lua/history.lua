#!/lounge/bin/janosh -f

function add(key, operation, value)
  print("add")
  obj = JSON:decode(value)
  name = tostring(Janosh:epoch()) .. "-" .. obj.title;
  pcall(function()
  Janosh:system("echo \"" .. tostring(Janosh:epoch()) .. " " .. obj.url .. " " .. obj.title ..  "\" >> /media/history")
  end)
  print("Added " .. value)
end

Janosh:subscribe("historyAdd", add)

Janosh:forever()

