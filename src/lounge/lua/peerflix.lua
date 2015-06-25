#!/lounge/bin/janosh -f

local util = require("util")

local function getPeerflixServerPid()
  return tonumber(Janosh:capture("netstat -anp | sed -n 's/.*0[.]0[.]0[.]0:9000 .* \\([0-9]*\\)\\/node/\\1/p'"))
end

Janosh:system("peerflix-server &")

-- wait for peerflix-server to bring the http server up
pid=nil
while pid == nil do
  pid=getPeerflixServerPid()
  Janosh:sleep(1000)
end

--get all torrents
json = Janosh:capture("wget -qO - http://localhost:9000/torrents")
array = JSON:decode(json)

-- pause all torrents
for i, obj in ipairs(array) do
  path = "/torrents/" .. obj["infoHash"] .. "/pause"
  Janosh:system("curl -X POST http://localhost:9000" .. path)
end

while true do
  Janosh:sleep(1000000)
end
