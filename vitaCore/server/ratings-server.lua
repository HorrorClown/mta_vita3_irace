--[[
Project: vitaCore
File: ratings-server.lua
Author(s):	Sebihunter
]]--

function loadRatings(mapname)
	local timesplayed = 0
	local ratingstable = {}

	local result = sql:queryFetchSingle("SELECT timesplayed, ratings FROM map_ratings WHERE mapname = ?", mapname)
	if result then
		timesplayed = result.timesplayed
		ratingstable = fromJSON(result.ratings)
	end

	return timesplayed, ratingstable
end

function saveRatings(mapname, timesplayed, ttable)
	local result = sql:queryFetchSingle("SELECT id FROM map_ratings WHERE mapname = ?", mapname)
	if result and result.id then
		sql:queryExec("UPDATE map_ratings SET ratings = ?, timesplayed = ? WHERE mapname = ?", toJSON(ttable), timesplayed, mapname)
	else
		sql:queryExec("INSERT INTO map_ratings (mapname, timesplayed, ratings) VALUES (?, ?, ?)", mapname, timesplayed, toJSON(ttable))
	end
end