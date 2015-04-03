#!/lounge/bin/janosh -f


function makeHostname(key, op, value) 
  Janosh:system("/root/shell/network makeHostname " .. Janosh:get("/network/hostname"))
end

function makeNetworkDhcp() 
    interface = Janosh:get("/network/connection/interface").connection.interface  
    Janosh:system("/root/shell/network makeNetworkDhcp " .. interface)
end

function makeNetworkMan()
  obj = Janosh:get("/network/.")
  Janosh:system("/root/shell/network makeNetworkMan " .. obj.connection.interface .. " " .. obj.address  .. " " .. obj.netmask  .. " " .. obj.gateway)
end

function addWifi()
  obj = Janosh:get("/network/.")
  Janosh:system("/root/shell/network addWifi " .. obj.wifi.encryption.value .. " " .. obj.wifi.ssid  .. " " .. obj.netmask  .. " " .. obj.gateway)
end

function makeNetwork()
  Janosh:transaction(function()
    makeHostname()
    if Janosh:get("/network/mode/value") == "DHCP" then
      makeNetworkDhcp()
    else
      makeNetworkMan()
    end
  end)
end

Janosh:subscribe("networkMake", makeNetwork)

while true do
  Janosh:sleep(100000)
end

