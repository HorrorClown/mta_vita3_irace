--[[
Project: vitaCore
File: toptimes_server.lua
Author(s):	Sebihunter
]]--

function loadTopTimes(mapname)
	mapname = string.gsub(tostring(mapname), "'", "")
	local toptimetable = {}
	if mysql_ping ( g_mysql["connection"] ) == false then
		onResourceStopMysqlEnd()
		onResourceStartMysqlConnection()
		return loadTopTimes(mapname)
	end
	local toptimes = mysql_query(g_mysql["connection"], "SELECT * FROM `toptimes` WHERE `mapname` = '"..mapname.."' LIMIT 0, 1")
	if toptimes then	
		local row = mysql_fetch_assoc(toptimes)
		if row then
			toptimetable = table.load(row["table"])
			mysql_free_result(toptimes)
		end
	end
	return toptimetable
end

function saveTopTimes(mapname, ttable)
	mapname = string.gsub(tostring(mapname), "'", "")
	if mysql_ping ( g_mysql["connection"] ) == false then
		onResourceStopMysqlEnd()
		onResourceStartMysqlConnection()
		saveTopTimes(mapname, ttable)
	end
	local result = mysql_query(g_mysql["connection"], "SELECT * FROM `toptimes` WHERE `mapname` = '"..mapname.."'")
	if result and mysql_num_rows(result) ~= 0 then
		mysql_query(g_mysql["connection"], "UPDATE `toptimes` SET `table` = '"..table.save(ttable).."' WHERE `mapname` = '"..mapname.."' LIMIT 1 ;")	
	else
		mysql_query(g_mysql["connection"], "INSERT INTO `toptimes` (`mapname`, `table`) VALUES ( '"..mapname.."', '"..table.save(ttable).."')")
	end
end

function addNewToptime(ttable, accname, ttime)
	for i,v in ipairs(ttable) do
		if v.name == accname then
			if v.time > ttime then
				v.time = ttime
				sortToptimes(ttable)
				return true
			end
			return false
		end
	end
	local playertable = {}
	playertable.name = accname
	playertable.time = ttime
	ttable[#ttable+1] = playertable
	sortToptimes(ttable)
	return true
end

function getPlayerToptimeInformation(ttable, accountname)
	for i,v in ipairs(ttable) do
		if v.name == accountname then
			local returntable = {}
			returntable.time = v.time
			returntable.id = i
			return returntable
		end
	end
	return false
end

function removeToptime(ttable, id)
	if ttable[id] then
		table.remove(ttable, id)
		sortToptimes(ttable)
	end
	return ttable
end

function sortToptimes(ttable)
	local bugged = false
	for i,v in ipairs(ttable) do
		if not v.time then
			outputServerLog ( "ToptimeData ("..tostring(ttable)..") failed: "..tostring(v.name).." - Removing players data" )
			table.remove(ttable, i)
		end
	end
	
	local old12 = ttable[12]
	table.sort(ttable, 
		function(a, b)
			return a.time < b.time
		end
	)
	local new12 = ttable[12]
	
	if old12 ~= new12 then
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(v, "AccountName") == old12.name then
				if getPlayerGameMode(v) == gGamemodeDM then
					setElementData(v, "TopTimes", getElementData(v, "TopTimes")-1)
					setElementData(v, "TopTimeCounter", getElementData(v, "TopTimeCounter")-1)			
				elseif getPlayerGameMode(v) == gGamemodeDM then
					setElementData(v, "TopTimesRA", getElementData(v, "TopTimesRA")-1)
				end
			end
		end
	end
	return ttable
end

function sendToptimes(player, ttable)
	if player then
		callClientFunction(player, "setToptimeTable", ttable)
		return true
	end
	return false
end

function getPlayerToptimeCount(player, prefix)
	local toptimeCount = 0

	if mysql_ping ( g_mysql["connection"] ) == false then
		onResourceStopMysqlEnd()
		hasPlayersLoaded = false
		onResourceStartMysqlConnection()
		return getPlayerToptimeCount(player, prefix)
	end	
	
	local result = mysql_query(g_mysql["connection"], "SELECT * FROM `toptimes` ORDER BY `id` ASC")
	if result then
		while true do
			local row = mysql_fetch_assoc(result)
			if not row then break end
			local skip = false
			if result then
				if not string.find (string.upper (row["mapname"]), prefix) then skip = true end
			end
			local toptimeTable = table.load(row["table"])
			if toptimeTable and type(toptimeTable) == "table" then
				for i = 1,12, 1 do
					if toptimeTable[i] then
						if toptimeTable[i].name == getElementData(player, "AccountName") and skip == false then
							toptimeCount = toptimeCount+1
						end
					end
				end
			end
		end
		mysql_free_result(result)
	end
	return toptimeCount
end