--[[
Project: vitaCore
File: toptimes_server.lua
Author(s):	Sebihunter
]]--

function loadTopTimes(mapname)
	local result = sql:queryFetchSingle("SELECT * FROM toptimes WHERE mapname = ?", mapname)
	if result then
		return fromJSON(result.table)
	else
		return {}
	end
end

function saveTopTimes(mapname, ttable)
    local result = sql:queryFetchSingle("SELECT id FROM toptimes WHERE mapname = ?", mapname)
    if result and result.id then
        sql:queryExec("UPDATE toptimes SET `table` = ? WHERE mapname = ?", toJSON(ttable), mapname)
    else
        sql:queryExec("INSERT INTO toptimes (mapname, `table`) VALUES (?, ?)", mapname, toJSON(ttable))
    end
end

function addNewToptime(ttable, accname, ttime)
	for i,v in ipairs(ttable) do
		if v.name == accname then
			if v.time > ttime then
				v.time = ttime
				v.date = getRealTime().timestamp
				sortToptimes(ttable)
				return true
			end
			return false
		end
	end
	
	local playertable = {}
	playertable.name = accname
	playertable.time = ttime
	playertable.date = getRealTime().timestamp
	
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

    local result = sql:queryFetch("SELECT * FROM toptimes ORDER BY id ASC")
    if result then
        for _, v in pairs(result) do
            if string.find(v.mapname, prefix) then
                local toptimeTable = fromJSON(v.table)
                if toptimeTable and type(toptimeTable) == "table" then
                    for i = 1, 12 do
                        if toptimeTable[i] and toptimeTable[i].name == getElementData(player, "AccountName") then
                            toptimeCount = toptimeCount + 1
                        end
                    end
                end
            end
        end
    end

    return toptimeCount
end
