#!/lounge/bin/janosh -f

local util = require("util")

local api_keys = {
  soundcloud = "2dcf4e12afd6ed5119741f888260fc85"
}


local HelpersClass = {} -- the table representing the class, which will double as the metatable for the instances
HelpersClass.__index = HelpersClass -- failed table lookups on the instances should fallback to the class table, to get methods

function HelpersClass.new()
  return setmetatable({}, HelpersClass)
end

function HelpersClass.resolve(self, url, category) 
  if category == "youtube" then
    if string.gmatch(url, "&v=") then
      url = url:gsub("&list=[a-zA-Z0-9]+", "")
    end
    print("#### URL:", url)
    return self:youtube_dl(url)
  elseif category == "magnet" then
    items={}
    title=string.match(url, "&dn=([0-9a-zA-z._+-]*)&")
    items[title]="http://localhost:9999/"
    return items
  else
    return self:youtube_dl(url)
  end
end

function HelpersClass.youtube_dl(self, url)
    p,i,o,e = Janosh:psystem("/usr/bin/youtube-dl --encoding utf-8 -g -e '" .. url .. "'")
    items={}
    title=""
    url=""
    while true do
      title = Janosh:preadLine(o)
      url = Janosh:preadLine(o)
      if title == nil or url == nil then break end
      items[title]=url
    end
    print("YOUTUBE_DL", title, url) 
    Janosh:pclose(i)
    Janosh:pclose(o)
    Janosh:pclose(e)
    Janosh:pwait(p)
    return items
end

function HelpersClass.soundcloud(self, url)
   local json = JSON:decode(
      util:http_get('http://api.soundcloud.com/resolve.json?' ..
                  'client_id=' .. api_keys.soundcloud .. '&url=' .. url))
   return json['stream_url'], json.user.username .. ' - ' .. json.title
end

function HelpersClass.jamendo(self, url)
   local html = util:http_get(url)
   local json = JSON:decode(
      string.match(html,"<object data%-response='([^']+)'")
         :gsub('&quot;', '"'):gsub('&amp;', '&'):gsub('&#92;', '\\'))
      .tracksmgr.tracks[1]
   return json.stream, json.artist.name .. ' - ' .. json.title
end

return HelpersClass.new()
