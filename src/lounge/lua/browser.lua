#!/lounge/bin/janosh -f
local midori = require("midori")

function open(key, op, value)
  obj = Janosh:get("/browser/.")
  url = obj.url
  category = obj.category
  active="browser"

  if category == "image" or category == "animation" then
    url="http://localhost/cgi-bin/makeImageView?" .. url
    active=category
  end
  midori:openUrl(url)
  --FIXME notify Loading category: url 
  Janosh:set_all({ "/image/active", "false",  "/browser/active", "false", "/animation/active", "false"});
  Janosh:trigger("/" .. category .. "/active", "true")
end

Janosh:subscribe("/browser/url", open)
Janosh:subscribe("browserClose", function(key,op,value) 
  midori:close() 
  Janosh:set_all({ "/image/active", "false",  "/browser/active", "false", "/animation/active", "false"});
end)

Janosh:subscribe("browserPageUp", function(key,op,value) midori:pageUp() end)
Janosh:subscribe("browserPageDown", function(key,op,value) midori:pageDown() end)
Janosh:subscribe("browserScrollUp", function(key,op,value) midori:scrollUp() end)
Janosh:subscribe("browserScrollDown", function(key,op,value) midori:scrollDown() end)
Janosh:subscribe("browserZoomIn", function(key,op,value) midori:zoomIn() end)
Janosh:subscribe("browserZoomOut", function(key,op,value) midori:zoomOut() end)

midori:run()
