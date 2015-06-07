#!/lounge/bin/janosh -f

Janosh:subscribe("historyAdd", function(key,op,value)
  sum = Janosh:capture("echo \"" .. value .. "\" | md5sum")
  name = tostring(Janosh:epoch()) .. "-" .. sum;
  Janosh:system("echo \"" .. value .. "\" > /ipns/local/" .. name)
end)


Janosh:system("/lounge/go/bin/ipfs daemon --mount")

