#!/lounge/bin/janosh -f


local function makeHostname()
  Janosh:system("/root/shell/network makeHostname " .. Janosh:get("/network/hostname").hostname)
end

local function makeNetworkDhcp() 
  interface = Janosh:get("/network/connection/interface").connection.interface  
  print("interface:", interface)
  Janosh:system("/root/shell/network makeNetworkDhcp " .. interface)
end

local function makeNetworkMan()
  obj = Janosh:get("/network/.")
  Janosh:system("/root/shell/network makeNetworkMan " .. obj.connection.interface .. " " .. obj.address  .. " " .. obj.netmask  .. " " .. obj.gateway)
end

local function addWifi()
  obj = Janosh:get("/network/.")
  Janosh:system("/root/shell/network addWifi " .. obj.wifi.encryption.value .. " " .. obj.wifi.ssid  .. " " .. obj.wifi.passphrase)
end

local function makeDns() 
  Janosh:system("/root/shell/network makeDns " .. Janosh:get("/network/nameserver").nameserver)
end

function make()
  Janosh:transaction(function()
    obj = Janosh:get("/network/.")
    makeHostname()
    if obj.mode.value == "DHCP" then
      makeNetworkDhcp()
    else
      makeNetworkMan()
      makeDns() 
    end
    print(obj.connection.value)
    if obj.connection.value == "Wifi" then
      print("wifi")
      addWifi()
    end
  end)
end

function reload()
  Janosh:transaction(function()
    p,i,o,e = Janosh:popen("/root/shell/network", "readWirelessNics")
    i=0
    while true do
      line = Janosh:preadLine(o)
      if line == nil then break end
      Janosh:set("/network/connection/wireless/choices/#" .. i, line)
      i = i + 1
    end
    Janosh:pclose(i)
    Janosh:pclose(o)
    Janosh:pclose(e)

    p,i,o,e = Janosh:popen("/root/shell/network", "readWiredNics")
    i=0
    while true do
      line = Janosh:preadLine(o)
      if line == nil then break end
      Janosh:set("/network/connection/wired/choices/#" .. i, line)
      i = i + 1
    end
    Janosh:pclose(i)
    Janosh:pclose(o)
    Janosh:pclose(e)

--    Janosh:system("/etc/init.d/networking stop")
--    Janosh:system("/etc/init.d/networking start")
  end)
end

Janosh:subscribe("networkMake", make)
Janosh:subscribe("networkReload", reload)
while true do
  Janosh:sleep(100000)
end

