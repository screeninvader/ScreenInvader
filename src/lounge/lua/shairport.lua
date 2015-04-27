#!/lounge/bin/janosh -f
local util = require("util")

function start(key, op, value)
  Janosh:transaction(function() 
    Janosh:publish("playerPause","W","");
    Janosh:system("killall shairport; shairport -a `cat /etc/hostname` &")
    if Janosh:get("/shairport/active").active == "false" then
      util:notifyLong("Activating shairport");
      Janosh:set_t("/shairport/active", "true")
    end
  end)
end

function stop(key,op,value) 
  Janosh:transaction(function()
    Janosh:system("killall shairport")
    if Janosh:get("/shairport/active").active == "true" then
      util:notifyLong("Deactivating shairport");
      Janosh:set_t("/shairport/active", "false")
      Janosh:publish("playerPlay","W","");
    end
  end)
end

Janosh:subscribe("shairportStart", start)
Janosh:subscribe("shairportStop", stop)

while true do
  Janosh:sleep(1000000)
end
