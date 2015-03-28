#!/lounge/bin/janosh -f

function setVolume(key, op, value)
  if op == "W" then
    device = Janosh:get("/sound/device").sound.device
    Janosh:system("amixer -D".. device .." sset PCM " .. value .. "%")
  end
end

function setMute(key,op,value)
  -- not implemented
end

Janosh:subscribe("/sound/volume", setVolume)
Janosh:subscribe("/sound/mute",  setMute)

while true do
  Janosh:sleep(1000000)
end


