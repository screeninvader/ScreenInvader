#!/lounge/bin/janosh -f

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
["radio"]='radio',
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
["putio"]='player'
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
print("open:",value)

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function getCategory(url)
  print("getCategory:", url)
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
    while location ~= "" do
      lastloc=location
      location=Janosh:capture("curl --head \"" .. location .. "\" | dos2unix | grep -iPo 'Location: \\K(.*)?(?=)'")
    end

    code=tonumber(Janosh:capture("curl --head \"" .. lastloc .. "\" | head -n 1 | cut -d ' ' -f 2"))
    if code ~= 200 then
      mimeType="video/fixed"
    else
      mimeType=Janosh:capture("curl --head \"" .. lastloc .. "\" | grep -iPo 'Content-Type: \\K(.*)?(?=)'")
    end  
  else
    file=url
    mimeType=Janosh:capture("file -i \"" .. file .. "\" | sed 's/.*: \\([a-zA-Z]*\\/[a-zA-Z]*\\).*/\\1/p' | sed '1d'")
  end

  if mimeType == "" then
    mimeType="video/fixed"
  end

  category=CATEGORY_FIX[mimeType]

  if category == nil then
    category=Janosh:capture("echo \"" .. mimeType .. "\" | cut -d'/' -f1")
  end
  return trim(category);
end

  url=value
  cat=getCategory(url)
  handler=CATEGORY_MAP[cat]
  print("triggering:", handler, "/", cat)
  if handler ~= nil then
    Janosh:set("/" .. handler .. "/category",cat)
    Janosh:trigger("/" .. handler .. "/url", url) 
  end
end

Janosh:subscribe("showUrl", open)

while true do
  Janosh:sleep(100000)
end


