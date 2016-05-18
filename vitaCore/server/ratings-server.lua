--[[
Project: vitaCore
File: ratings-server.lua
Author(s):	Sebihunter
]]--

function loadRatings(mapname)
	--mapname = string.gsub(tostring(mapname), "'", "")
	local timesplayed = 0
	local ratingstable = {}

	if mysql_ping(g_mysql["connection"]) == false then
		onResourceStopMysqlEnd()
		onResourceStartMysqlConnection()
		return loadRatings(mapname)
	end

	local ratings = mysql_query(g_mysql["connection"], "SELECT * FROM `map_ratings` WHERE `mapname` = '"..mapname.."' LIMIT 0, 1")

	if ratings then	
		local row = mysql_fetch_assoc(ratings)
		if row then
			timesplayed = tonumber(row["timesplayed"])
			ratingstable = fromJSON(row["table"])
			mysql_free_result(ratings)
		end
	end

	return timesplayed, ratingstable
end

function saveRatings(mapname, timesplayed, ttable)
	--mapname = string.gsub(tostring(mapname), "'", "")

	if mysql_ping ( g_mysql["connection"] ) == false then
		onResourceStopMysqlEnd()
		onResourceStartMysqlConnection()
		saveRatings(mapname, ttable)
	end

	local result = mysql_query(g_mysql["connection"], "SELECT * FROM `map_ratings` WHERE `mapname` = '"..mapname.."'")
	if result and mysql_num_rows(result) ~= 0 then
		mysql_query(g_mysql["connection"], "UPDATE `map_ratings` SET `timesplayed` = '"..tostring(timesplayed).."',`table` = '"..toJSON(ttable).."' WHERE `mapname` = '"..mapname.."' LIMIT 1 ;")
	else
		mysql_query(g_mysql["connection"], "INSERT INTO `map_ratings` (`mapname`, `timesplayed`, `table`) VALUES ( '"..mapname.."', '"..tostring(timesplayed).."', '"..toJSON(ttable).."')")
	end
end