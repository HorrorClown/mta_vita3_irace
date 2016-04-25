--[[
Project: vitaCore
File: utils-server.lua
Author(s):	Sebihunter
]]--

--calls a server function. Not triggerable by client!
function callServerFunction(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end

function callClientFunction(client, funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    -- If the clientside event handler is not in the same resource, replace 'resourceRoot' with the appropriate element
    triggerClientEvent(client, "onServerCallsClientFunction", resourceRoot, funcname, unpack(arg or {}))
end


function escapeString(theString)
	if type(theString) ~= "string" then return theString end
	return mysql_escape_string(g_mysql["connection"], theString)
end


function setRedoCounter(gamemode, value)
	if gamemode == 1 then
		gRedoCounterSH = value
	elseif gamemode == 2 then
		gRedoCounterDD = value
	elseif gamemode == 3 then
		gRedoCounterRA = value
	elseif gamemode == 5 then
		gRedoCounterDM = value
	end
end

function getRedoCounter(gamemode)
	if gamemode == 1 then
		return gRedoCounterSH
	elseif gamemode == 2 then
		return gRedoCounterDD
	elseif gamemode == 3 then
		return gRedoCounterRA
	elseif gamemode == 5 then
		return gRedoCounterDM
	end
end

--Leere Tabelle serialized: return {{},}--|

local function exportstring( s )
	s = string.format( "%q",s )

	s = string.gsub( s,"\\\n","\\n" )
	s = string.gsub( s,"\r","\\r" )
	s = string.gsub( s,string.char(26),"\"..string.char(26)..\"" )
	return s
end

function table.save(tbl)
	if tbl == nil then return "return {{},}--|" end
	
	local charS,charE = "   ","\n"
	local file,err
	local filename = nil

	file =  { write = function( self,newstr ) self.str = self.str..newstr end, str = "" }
	charS,charE = "",""

	local tables,lookup = { tbl },{ [tbl] = 1 }
	file:write( "return {"..charE )
	for idx,t in ipairs( tables ) do
		if filename and filename ~= true and filename ~= 1 then
			file:write( "-- Table: {"..idx.."}"..charE )
		end
		file:write( "{"..charE )
		local thandled = {}
		for i,v in ipairs( t ) do
			thandled[i] = true
			if type( v ) ~= "userdata" then
				if type( v ) == "table" then
					if not lookup[v] then
						table.insert( tables, v )
						lookup[v] = #tables
				end
				file:write( charS.."{"..lookup[v].."},"..charE )
            elseif type( v ) == "function" then
               file:write( charS.."loadstring("..exportstring(string.dump( v )).."),"..charE )
            else
               local value =  ( type( v ) == "string" and exportstring( v ) ) or tostring( v )
               file:write(  charS..value..","..charE )
            end
		end
	end
	for i,v in pairs( t ) do
         if (not thandled[i]) and type( v ) ~= "userdata" then
            if type( i ) == "table" then
               if not lookup[i] then
                  table.insert( tables,i )
                  lookup[i] = #tables
               end
               file:write( charS.."[{"..lookup[i].."}]=" )
            else
               local index = ( type( i ) == "string" and "["..exportstring( i ).."]" ) or string.format( "[%d]",i )
               file:write( charS..index.."=" )
            end
            if type( v ) == "table" then
               if not lookup[v] then
                  table.insert( tables,v )
                  lookup[v] = #tables
               end
               file:write( "{"..lookup[v].."},"..charE )
            elseif type( v ) == "function" then
               file:write( "loadstring("..exportstring(string.dump( v )).."),"..charE )
            else
               local value =  ( type( v ) == "string" and exportstring( v ) ) or tostring( v )
               file:write( value..","..charE )
            end
         end
		end
		file:write( "},"..charE )
	end
	file:write( "}" )

	return file.str.."--|"
end

function table.load( sfile )
	if not sfile then return {} end
	local tables, err = loadstring( sfile )
	if err then return _,err end
	tables = tables()
	for idx = 1,#tables do
		local tolinkv,tolinki = {},{}
		for i,v in pairs( tables[idx] ) do
			if type( v ) == "table" and tables[v[1]] then
				table.insert( tolinkv,{ i,tables[v[1]] } )
			end
			if type( i ) == "table" and tables[i[1]] then
				table.insert( tolinki,{ i,tables[i[1]] } )
			end
		end
		for _,v in ipairs( tolinkv ) do
			tables[idx][v[1]] = v[2]
		end
		for _,v in ipairs( tolinki ) do
			tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
		end
	end
	return tables[1]
end

setPlayerMoney_ = setPlayerMoney
function setPlayerMoney(player, toggle)
	if player then
		setElementData(player, "Money", toggle)
	end
end

getPlayerMoney_ = getPlayerMoney
function getPlayerMoney(player)
	if player then
		return getElementData(player, "Money")
	end
end

givePlayerMoney_ = givePlayerMoney
function givePlayerMoney(player,ammount)
	if player then
		setElementData(player, "Money", getElementData(player, "Money")+ammount)
	end
end

function executeServerCommandHandler(commandHandler, args)
	executeCommandHandler(commandHandler, source, args)
end
addEvent("executeServerCommandHandler", true)
addEventHandler("executeServerCommandHandler", getRootElement(), executeServerCommandHandler)

function outputChatBoxToGamemode(text, id, r,g,b, colorCoded)
	for i,v in pairs(getGamemodePlayers(id)) do
		outputChatBox(text, v, r,g,b, colorCoded)
	end
end
addEvent("outputChatBoxToGamemode", true)
addEventHandler ( "outputChatBoxToGamemode", getRootElement(), outputChatBoxToGamemode )

local donatorBonusTable = {}
function getDonatorBonusState(player, name, maxnum)
	if isElement(player) and getElementData(player, "isDonator") == true then
		if not donatorBonusTable[player] then donatorBonusTable[player] = {} end
		if not donatorBonusTable[player][tostring(name)] then donatorBonusTable[player][tostring(name)] = 0 end
		if maxnum and maxnum > donatorBonusTable[player][tostring(name)] then
			return true
		end
	end
	return false
end

function getDonatorBonusNumber(player, name)
	if isElement(player) and getElementData(player, "isDonator") == true then
		if not donatorBonusTable[player] then donatorBonusTable[player] = {} end
		if not donatorBonusTable[player][tostring(name)] then donatorBonusTable[player][tostring(name)] = 0 end
		return donatorBonusTable[player][tostring(name)]
	end
	return false
end

function incraseDonatorBonusState(player, name)
	if isElement(player) and getElementData(player, "isDonator") == true then
		if not donatorBonusTable[player] then donatorBonusTable[player] = {} end
		if not donatorBonusTable[player][tostring(name)] then donatorBonusTable[player][tostring(name)] = 0 end
		donatorBonusTable[player][tostring(name)] = donatorBonusTable[player][tostring(name)]+1
		return true
	end
	return false
end