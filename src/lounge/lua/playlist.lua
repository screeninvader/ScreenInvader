#!/lounge/bin/janosh -f


function remove(key, op, value)
  Janosh:remove("/playlist/items/#" .. value)
end

function clear(key, op, value)
  Janosh:transaction(function()
    Janosh:remove("/playlist/items/.")
    Janosh:mkarr("/playlist/items/.")
  end)
end

Janosh:subscribe("playlistRemove",  remove)
Janosh:subscribe("playlistClear", clear)

while true do
  Janosh:sleep(1000000)
end
