#!/lounge/bin/janosh -f

function setVolume(key, op, value)
  print("setVolume", value)
  device = Janosh:get("/sound/device")
  print("amixer -D".. device .." sset PCM " .. value .. "%")
  Janosh:system("amixer -D".. device .." set PCM " .. value .. "%")
end

function setMute(key,op,value)
  print("setMute",value)
  -- not implemented
end

Janosh:subscribe("setVolume", setVolume)
Janosh:subscribe("setMute",  setMute)

Janosh:forever()


