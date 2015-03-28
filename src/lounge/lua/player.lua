#!/lounge/bin/janosh -f
local mplayer = require("mplayer")

function open()
  obj=Janosh:get("/player/.")
  url=obj.url
  category=obj.category
  videoUrl=""
  title=""

  if category ~= "video" then
    ypid, ystdin, ystdout, ystderr = Janosh:popen("/usr/bin/youtube-dl","--encoding", "utf-8", "-g", "-e", url)
    title = Janosh:preadLine(ystdout)
    videoUrl = Janosh:preadLine(ystdout)
    videoUrl = string.gsub(videoUrl, "https://", "http://")
  else
    videoUrl = url
    title = basename(url)
  end
  mplayer:add(videoUrl, title, url)
end

Janosh:subscribe("/player/url", open)

mplayer:run()
