#!/lounge/bin/janosh -f
local util = require("util")
local mupdf = require("mupdf")

function open(key, op, value)
  Janosh:publish("browserClose","W", "")
  print("open:", value)
  obj = Janosh:get("/pdf/.")
  url = obj.url

  tmpfile = util:trim(Janosh:capture("mktemp"))
  Janosh:system("wget -O" .. tmpfile .. " \"".. url .. "\"")  
 
  mupdf:openFile(tmpfile)
  cnt=0
  while util:getWindowID("mupdf.MuPDF") == -1 and cnt < 10 do
    Janosh:sleep(500)
    cnt = cnt + 1
  end

  Janosh:system("rm " .. tmpfile)

--FIXME notify Loading category: url 
  Janosh:trigger("/pdf/active", "true")
end

Janosh:subscribe("/pdf/url", open)
Janosh:subscribe("pdfClose", function(key,op,value)
  mupdf:close()
  Janosh:trigger("/pdf/active", "false")
end)

Janosh:subscribe("pdfPageUp", function(key,op,value) mupdf:pageUp() end)
Janosh:subscribe("pdfPageDown", function(key,op,value) mupdf:pageDown() end)
Janosh:subscribe("pdfScrollUp", function(key,op,value) mupdf:scrollUp() end)
Janosh:subscribe("pdfScrollDown", function(key,op,value) mupdf:scrollDown() end)
Janosh:subscribe("pdfScrollLeft", function(key,op,value) mupdf:scrollLeft() end)
Janosh:subscribe("pdfScrollRight", function(key,op,value) mupdf:scrollRight() end)
Janosh:subscribe("pdfZoomIn", function(key,op,value) mupdf:zoomIn() end)
Janosh:subscribe("pdfZoomOut", function(key,op,value) mupdf:zoomOut() end)

mupdf:run()
