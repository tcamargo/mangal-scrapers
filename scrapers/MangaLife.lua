---------------------------------------
-- @name    MangaLife 
-- @url     https://www.manga4life.com/
-- @author  Tiago Camargo 
-- @license MIT
---------------------------------------


---@alias manga { name: string, url: string, author: string|nil, genres: string|nil, summary: string|nil }
---@alias chapter { name: string, url: string, volume: string|nil, manga_summary: string|nil, manga_author: string|nil, manga_genres: string|nil }
---@alias page { url: string, index: number }


----- IMPORTS -----
Headless = require("headless")
Html = require("html")
HttpUtil = require("http_util")
Inspect = require('inspect')
Time = require("time")
Log = require("log")
info = Log.new()
--- END IMPORTS ---




----- VARIABLES -----
Browser = Headless.browser()
Base = "https://www.manga4life.com"
info:set_prefix("[INFO] ")
info:set_flags({date=true, time=true})
--- END VARIABLES ---


----- MAIN -----

--- Searches for manga with given query.
-- @param query string Query to search for
-- @return manga[] Table of mangas
function SearchManga(query)
    local page = Browser:page()

    -- https://www.manga4life.com/search/?sort=v&desc=true&name=fairy%20tail
    local url = Base .. "/search/?sort=v&desc=true&name=" .. HttpUtil.query_escape(query)
    page:navigate(url)
    page:waitLoad()

    -- waitLoad() doesn't consider dynamic loaded elements
    -- try 5 times, slepping 1s before each try, to find manga entries
    local selector = ".col-md-10 > .SeriesName"
    local try = 1
    while try <= 5 do
        if page:has(selector) then
            break
        end
        info:printf("Waiting... Retry %i.", try)
        Time.sleep(1)
        try = try + 1
    end
    
    info:printf("Found %i mangas.", #page:elements(selector))

    local mangas = {}

    for _, v in ipairs(page:elements(selector)) do
        local manga = { name = v:text(), url = Base .. v:attribute('href') }
        table.insert(mangas, manga)
    end

    -- print(Inspect(mangas))
    -- error("Avoid cache...")

    return mangas
end


--- Gets the list of all manga chapters.
-- @param mangaURL string URL of the manga
-- @return chapter[] Table of chapters
function MangaChapters(mangaURL)
	local page = Browser:page()
    info:printf("Manga URL %s", mangaURL)
	page:navigate(mangaURL)
	page:waitLoad()

    print("1")

	if page:has('.ShowAllChapters') == true then
        print("2")
		page:element('.ShowAllChapters'):click()
	end

    print("3")

    local selector = ".ChapterLink"
	local chapters = {}

    info:printf("Found %i chapters.", #page:elements(selector))

	-- doc:find(".ChapterLink"):each(function(i, s)
	-- 	local name = s:find('span'):first():text()
	-- 	name = Strings.trim(name:gsub("[\r\t\n]+", " "), " ")
	-- 	local chapter = { name = name, url = Base .. s:attr("href") }
	-- 	chapters[i + 1] = chapter
	-- end)

	-- Reverse(chapters)

    error("Avoid cache...")
	return {}
end


--- Gets the list of all pages of a chapter.
-- @param chapterURL string URL of the chapter
-- @return page[]
function ChapterPages(chapterURL)
    error("Avoid cache...")
	return {}
end

--- END MAIN ---




----- HELPERS -----
--- END HELPERS ---

-- ex: ts=4 sw=4 et filetype=lua
