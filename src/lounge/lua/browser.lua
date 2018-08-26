#!/lounge/bin/janosh -f
local midori = require("midori")

function open(key, op, value)
  print("open:", value)
  Janosh:publish("pdfClose","W","")
  print("publish")
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
  Janosh:set_all({ "/image/active", "false",  "/browser/active", "false", "/animation/active", "false"})
  Janosh:set_t("/" .. active .. "/active", "true");
end

Janosh:subscribe("/browser/url", open)
Janosh:subscribe("browserClose", function(key,op,value) 
  midori:close() 
  Janosh:transaction(function()
    obj = Janosh:get({ "/image/active", "/browser/active", "/animation/active"})
    if obj.browser.active == "true" or obj.image.active == "true" or obj.animation.active == true then
      Janosh:set_all({ "/image/active", "false",  "/browser/active", "false", "/animation/active", "false"})
      Janosh:set_t("/browser/active", "false");
    end
  end)
end)

--Janosh:subscribe("browserPageUp", function(key,op,value) midori:pageUp() end)
--Janosh:subscribe("browserPageDown", function(key,op,value) midori:pageDown() end)
Janosh:subscribe("browserScrollUp", function(key,op,value) midori:scrollUp() end)
Janosh:subscribe("browserScrollDown", function(key,op,value) midori:scrollDown() end)
Janosh:subscribe("browserScrollLeft", function(key,op,value) midori:scrollLeft() end)
Janosh:subscribe("browserScrollRight", function(key,op,value) midori:scrollRight() end)
Janosh:subscribe("browserZoomIn", function(key,op,value) midori:zoomIn() end)
Janosh:subscribe("browserZoomOut", function(key,op,value) midori:zoomOut() end)

midori:run()
