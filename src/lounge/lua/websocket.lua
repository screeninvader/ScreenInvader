#!/lounge/bin/janosh -f

local util = require("util")
function receive(handle, message)
  Janosh:transaction(function()
    if message == 'setup' then
      util:notify("New client connected: " .. handle)
      print(">>>>>>>>>>>>>>>>>>>>>> new client")
      Janosh:wsSend(handle, janosh_request({"get","/."}))
      print(">>>>>>>>>>>>>>>>>>>>>> sent")
    else
      print("received", message)
      janosh_request(JSON:decode(message))
    end
  end)
end

function push(key, op, value)
   print('push updates')
  Janosh:wsBroadcast(JSON:encode({key, op, value}))
end

Janosh:wsOpen(8080)
Janosh:wsOnReceive(receive)
Janosh:subscribe("/", push)

while true do
   Janosh:sleep(1000000) -- milliseconds
end
