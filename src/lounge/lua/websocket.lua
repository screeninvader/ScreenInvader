#!/lounge/bin/janosh -f

local util = require("util")
function receive(handle, message)
  Janosh:transaction(function()
    if message == 'setup' then
      util:notify("New client connected: " .. handle)
      Janosh:wsSend(handle, janosh_request({"get","/."}))
    else
      print("received", message)
      local tmsg = JSON:decode(message)
      Janosh:publish(tmsg[2], tmsg[4])
    end
  end)
end

function push(key, op, value)
  Janosh:wsBroadcast(JSON:encode({key, op, value}))
end

Janosh:wsOpen(8080)
Janosh:wsOnReceive(receive)
Janosh:subscribe("", push)

Janosh:forever()

