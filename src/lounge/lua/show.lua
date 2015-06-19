#!/lounge/bin/janosh -f

local util = require("util")
local VIDEO_HOSTS={
["grooveshark.com/"]='youtube',
["youtube.com/"]='youtube',
["youtu.be/"]='youtube',
["vine.com/"]='youtube',
["tvthek.orf.at/"]='orf',
["videos.arte.tv/"]='arte7',
["vimeo.com/"]='vimeo',
["soundcloud.com/"]='soundcloud',
["ted.com/"]='ted',
["jamendo.com/"]='jamendo',
["bandcamp.com/"]='bandcamp',
["tindeck.com/"]='tindeck',
["put.io/"]='putio'
}

local CATEGORY_MAP={
["video"]='player',
["multipart"]='browser',
["audio"]='player',
["image"]='browser',
["animation"]='browser',
["radio"]='player',
["text"]='browser',
["pdf"]='pdf',
["youtube"]='player',
["orf"]='player',
["arte7"]='player',
["vimeo"]='player',
["soundcloud"]='player',
["ted"]='player',
["jamendo"]='player',
["bandcamp"]='player',
["tindeck"]='player',
["joker"]='player',
["putio"]='player',
["magnet"]='player'
}

local CATEGORY_FIX={
["application/octet-stream"]='video',
["application/x-matroska"]='video',
["audio/x-mpegurl"]='radio',
["application/pls"]='radio',
["application/pdf"]='pdf',
["audio/x-scpls"]='radio',
["image/gif"]='animation',
["application/ogg"]='video',
["application/x-bittorrent"]='joker'
}


function open(key, op, value)
util:notify("Resolving url: " .. value)
print("open:",value)

function ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function getCategory(url)
  print("getCategory:", url)
  if string.match(url, "magnet:?") then
    return "magnet"
  end

  hUrl=string.match(url, "http[s]*://([0-9a-zA-z.-_]*/)")
  if hUrl ~= nil then
    for host,category in pairs(VIDEO_HOSTS) do
      print(hUrl,host);
      if ends(hUrl,host) then
        return category
      end    
    end  
  end

  mimeType="unknown/"

  if string.match(url, "http[s]*://") then
    head=""
    location=url
    lastloc=url
    while location ~= nil do
      lastloc=location
      p, i, o, e = Janosh:popen("curl", "--head", location)
      line=""
      head=""
      while true do
        line=Janosh:preadLine(o)
        if line == nil then break end
        head= head .. string.gsub(line, "\r", "\n")
      end
      Janosh:pclose(i)
      Janosh:pclose(e)
      Janosh:pclose(o)
      Janosh:pwait(p)
      p, i, o, e = Janosh:popen("grep", "-iPo", "Location: \\K(.*)?(?=)")
      Janosh:pwrite(i, head)
      Janosh:pclose(i)
      location=Janosh:preadLine(o)
      Janosh:pclose(i)
      Janosh:pclose(e)
      Janosh:pclose(o)
      Janosh:pwait(p)
    end

    line=util:split(head,"\n")[1]
    token=util:split(line," ")[2]
    code=tonumber(token)
    print("code:", code)
    if code ~= 200 then
      mimeType="video/fixed"
    else
      mimeType=Janosh:capture("curl --head \"" .. lastloc .. "\" | grep -iPo 'Content-Type: \\K(.*)?(?=)'")
    end  
  elseif string.match(url, "[a-zA-Z]+://") then
    mimeType = "video/fixed"
  else
    file=url
    mimeType=Janosh:capture("file -i \"" .. file .. "\" | sed 's/.*: \\([a-zA-Z]*\\/[a-zA-Z]*\\).*/\\1/p' | sed '1d'")
  end
  mimeType=util:trim(mimeType)
  
  if mimeType == nil or mimeType == "" then
    return nil
  end

  category=CATEGORY_FIX[mimeType]
  if category == nil then
    category=Janosh:capture("echo \"" .. mimeType .. "\" | cut -d'/' -f1")
  end
  return util:trim(category);
end

  url=value
  cat=getCategory(url)
  handler=CATEGORY_MAP[cat]
  print("triggering:", handler, "/", cat)
  if handler ~= nil then
    Janosh:set_all_t({"/" .. handler .. "/category",cat, "/" .. handler .. "/url", url}) 
  else
    util:exception("Unable to handle url: " .. url)
  end
end

Janosh:subscribe("showUrl", open)

while true do
  Janosh:sleep(100000)
end


