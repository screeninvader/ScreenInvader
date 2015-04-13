#!/lounge/bin/janosh -f


function remove(key, op, value)
  Janosh:transaction(function()
    value = tonumber(value)
    idx = tonumber(Janosh:get("/playlist/index").index)
    Janosh:remove_t("/playlist/items/#" .. value .. "/.")
    if value < idx then
      Janosh:set_t("/playlist/index", idx - 1);
    end
  end)
end

function clear(key, op, value)
  Janosh:transaction(function()
    Janosh:remove_t("/playlist/items/.")
    Janosh:mkarr_t("/playlist/items/.")
  end)
end

function shift(key,op,value)
  param = JSON:decode(value)
  Janosh:shift_t("/playlist/items/#" .. param.from .. "/.", "/playlist/items/#" .. param.to .. "/.")
end

function load(key,op,value)
  Janosh:transaction(function()
    urls = JSON:decode(value)
    for u in urls do
      Janosh:publish("showUrl", "W", u);
    end
  end)
end

Janosh:subscribe("playlistRemove",  remove)
Janosh:subscribe("playlistClear", clear)
Janosh:subscribe("playlistShift", shift)
Janosh:subscribe("playlistLoad", load)

while true do
  Janosh:sleep(1000000)
end
