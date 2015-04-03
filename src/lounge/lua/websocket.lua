#!/lounge/bin/janosh -f

function receive(handle, message)
   if message == 'setup' then
      print("new client")
      Janosh:wsSend(handle, janosh_get({"/."}))
   else
      print("received", message)
      janosh_request(JSON:decode(message))
   end
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
