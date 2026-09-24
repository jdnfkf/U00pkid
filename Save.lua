local scripts = {
    [104841616983113] = "https://raw.githubusercontent.com/jdnfkf/U00pkid/main/ANSNV9.5.lua"
}

local url = scripts[game.PlaceId]
if url then
    loadstring(game:HttpGet(url))()
end