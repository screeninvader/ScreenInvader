#!/lounge/bin/janosh -f

local api_keys = {
  soundcloud = "2dcf4e12afd6ed5119741f888260fc85"
}

function split_once(str, sep)
   return string.match(str, '([^'..sep..']+)'..sep..'([^'..sep..']+)')
end

function http_get(url)
   return Janosh:capture("/usr/bin/curl -s -L '" .. url .. "'", true)
end

function youtube_dl(url)
   local result = Janosh:capture(
      "/usr/bin/youtube-dl --prefer-insecure -g -e '" .. url .. "'", true)
   return split_once(result, '\n')
end

function soundcloud(url)
   local json = JSON:decode(
      http_get('http://api.soundcloud.com/resolve.json?' ..
                  'client_id=' .. api_keys.soundcloud .. '&url=' .. url))
   return json['stream_url'], json.user.username .. ' - ' .. json.title
end

function jamendo(url)
   local html = http_get(url)
   local json = JSON:decode(
      string.match(html,"<object data%-response='([^']+)'")
         :gsub('&quot;', '"'):gsub('&amp;', '&'):gsub('&#92;', '\\'))
      .tracksmgr.tracks[1]
   return json.stream, json.artist.name .. ' - ' .. json.title
end
