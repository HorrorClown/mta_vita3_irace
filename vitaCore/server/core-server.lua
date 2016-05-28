--[[
Project: vitaCore
File: core-server.lua
Author(s):	Sebihunter
]]--

gValidatedSerials = {
	"746BA7FF343C9A6567670CC40BA89483", -- Corby
	"DD83E2D619CBEE22F2F0C1FCFFB5D0B2", -- Tazmaniiac
	"3F08D8E47AC51135763CD7739094A2E3", -- Sebihunter
	"5989A24A123C6E0B9BD0113F1DFD9142", -- ExXoTicC
	"CE752C7D8E1017B4B24C0F13AAD015F3", -- FaZe
	"0B5BDA8143D94FA0781B3B02132E30E3", -- SickStar
	"784360805E54DE9590E7967DFC32BB42", -- Jones
	"3C7486567C17D6F3A9FF5A059A95C971", -- pr0mise
	"31E64C06FFE925AF76890C5016D18E42", -- fudel
	"E6BAFEAAA8911700C6D35ABD1B6BA492", -- DeSmith
	"5EE4C64794B9C57A33777CEB3F48A152", -- Snicker
	"7588F81135E5AFA7E05E0A4B8977AFB3", -- Shurelya (Anzy)
	"590F6E881955B068AB44D28A598F5BB4", -- xDemo
	"8D6464CF45CDE784C510AD1BE90D0BB3", -- Schranzeule
	"9F768B86DFEA317CCDE681813CBACE43", -- NiKe
	"4CAEE9DC04C6C728D0281C14A884B8A1", -- Jogy
	"385D0EB9D4445885162CA7AB3B4B6843", -- #Dome
	"0E3F7623A19D2D621EBBA02608251C94", -- Hypnotic
	"B9CDD9247D3ED93D784E820FE20CB2F4", -- d0pe
	"A099F9A884C7335DA3CE8693E943DD03", -- Tobes
	"00495461C761DA10AAD9CD4433B14854",-- Olymp
	"9435E70DFBCFD6BA67207F64EA0ADB02",-- Agendc
	"795D8E105A00BD18E0A70B71E56E1052", -- Radion
	"F862655CB83EA36DD6739EBC4397A6E3", -- ChRiiz
	"A5C76A9EEDF9987CDD15AD025CE5CC03", -- LioNKinG
	"D06C8B4A9EE15B5101B83018984412A1", -- Adlerauge
	"D76402F897B2AE29FE9EAD8E335EFE94", -- Vaali
	"7C598491345A2F8123D637C80D877843", -- [D]ubStep
	"86CD3DAE29F29939B0672B3C782583A1", -- Gerard
	"493DB592AD0E6F13DABD3249D3B2C442", -- Leyo
	"01806A6F41213EB886AB76DE5B99B493", -- Dragonfire/Nitaco
	"65492A132DD29A4337E90568556E87F3", -- Dubz
	"794AE8EE11CF2477FA25D3C0B9090F44", -- revliS
	"7633AE9978AF762BC410A9597E9F20A2" -- Cookie
}

gPlayerBlips = {}

--[[function checkIfValidated (playerNick, playerIP, playerUsername, playerSerial, playerVersionNumber)
	local isValidated = false
	for i,v in ipairs(gValidatedSerials) do
		if playerSerial == v then
			isValidated = true
		end
	end
	if isValidated == false then cancelEvent(true,"YOU SHALL NOT PASS") end
end
addEventHandler ("onPlayerConnect", getRootElement(), checkIfValidated)]]

gRaceModes = {
	[1] = { name = "Shooter", img="files/selection/vitaSH.png", imghover = "files/selection/vitaSHhover.png", res = "vitaMapSH", joinfunc = "joinSH", quitfunc = "quitSH", loadfunc = "loadMapSH",  element="elementSH", killfunc="killSHPlayer", maxplayers = 32, prefix="SHOOTER", maps = {} },
	[2] = { name = "Destruction Derby", img="files/selection/vitaDD.png", imghover = "files/selection/vitaDDhover.png", res = "vitaMapDD", joinfunc = "joinDD", quitfunc = "quitDD", loadfunc = "loadMapDD", element="elementDD", killfunc="killDDPlayer", maxplayers = 32, prefix="DD", maps = {} },
	[3] = { name = "Race", img="files/selection/vitaRA.png", imghover = "files/selection/vitaRAhover.png", res = "vitaMapRA", joinfunc = "joinRA", quitfunc = "quitRA", loadfunc = "loadMapRA", element="elementRA", killfunc="killRAPlayer", maxplayers = 32, prefix="RACE", maps = {} },
	[4] = { name = "Minigames", img="files/selection/vitaFUN.png", imghover = "files/selection/vitaFUNhover.png", res = "vitaMapFUN", joinfunc = "joinFUN", quitfunc = "quitFUN", loadfunc = "loadModeFUN", element="elementFUN", killfunc="killFUNPlayer", maxplayers = 32, prefix="FUN", maps = {} },
	[5] = { name = "Deathmatch", img="files/selection/vitaDM.png", imghover = "files/selection/vitaDMhover.png", res = "vitaMapDM", joinfunc = "joinDM", quitfunc = "quitDM", loadfunc = "loadMapDM", element="elementDM", killfunc="killDMPlayer", maxplayers = 32, prefix="DM", maps = {} },
	[6] = { name = "Monopoly", img="files/selection/vitaNone.png", imghover = "files/selection/vitaNonehover.png", res = "vitaMapMO", joinfunc = "joinMO", quitfunc = "quitMO", loadfunc = "loadMapMO", element="elementMO", killfunc="killMOPlayer", maxplayers = 32, prefix="MO", maps = {} }
}

recruitTeam = createTeam ( "Recruit", 0, 51, 221 )
memberTeam = createTeam ( "Member", 0, 119, 255 )
seniorTeam = createTeam ( "SeniorMember", 0, 187, 255)
moderatorTeam = createTeam ( "Moderator", 0, 189, 57 )
globalTeam = createTeam ( "GlobalModerator", 0, 243, 113 )
donatorTeam = createTeam ( "Donator", 194,103,255 )
adminTeam = createTeam ( "Admin", 130, 134, 134 )

RandomMes = {
	[1] = "Read and obey the rules (Show the help with 'F1')!",
	[2] = "Low FPS? Try disabling graphical features in the userpanel.",
	[3] = "The main chat is english only. You can access the language chat with 'L'.",
	[4] = "Post your Map at 'irace-mta.de'.",
	[5] = "Apply at 'irace-mta.de'.",
	[6] = "Press 'U' for the userpanel and shop.",
	[7] = "If you want to help donate at 'irace-mta.de'.",
	[8] = "Use 'F2' to change the carfade options, 'F3' to leave the mode.",
	[9] = "To start a player versus player (PVP) war use /pvp [name] [money]."
}
--Todo: discuss about an alternate
--setTimer( function() outputChatBox(":SERVER: #FFFFFF"..RandomMes[math.random(1, #RandomMes)], getRootElement(), 255, 0, 0, true) end, 150000, 0 )

pLogger = {}

local hornTime = {}

function playerJoin()
	setPlayerNametagShowing ( source, false )
	setPlayerNametagText ( source, getPlayerName(source) )
	setElementData(source, "gameMode", 0)
	setElementData(source, "isLoggedIn", false)
	setElementData(source, "IP", tostring(getPlayerIP ( source )))
	setElementData(source, "Serial", tostring(getPlayerSerial ( source )))
	setElementDimension(source, 0)
	setElementInterior(source, 0)
	spawnPlayer(source, 0,0,0)
	callClientFunction ( source, "setTime", 12,0)	
	callClientFunction ( source, "setMinuteDuration", 60000)	
	toggleControl ( source, "vehicle_secondary_fire", true )
	toggleControl ( source, "vehicle_fire", true )
	setElementData(source, "country", getPlayerCountry ( source ))
	setElementData(source, "AFK", false)
	setElementData(source, "warnAFK", false)
	setElementData(source, "actionFPS", false)
	setElementData(source, "actionPing", false)
	setElementData(source, "nextMarker", 0)
	setElementData(source, "language", 1)
	hornTime[source] = false	
	gPlayerBlips[source] = createBlipAttachedTo ( source, 0, 1, 255,255,255,255, -1 )
	setElementVisibleTo ( gPlayerBlips[source], getRootElement(), false)
	
	for i,v in ipairs(gMutes) do
		if v.serial == getPlayerSerial(source) then 
			setPlayerMuted(source, true)
		end
	end	
	
	bindKey(source, "horn", "down", function(player, key, keyState)
		if getElementData(player, "state") == "alive" and getElementData(player, "usedHorn") ~= 0 and hornTime[player] == false then
			hornTime[player] = true
			for id,rply in pairs(getGamemodePlayers(getPlayerGameMode(player))) do
				if getElementData(rply, "toggleHorns") == 1 then
					callClientFunction(rply, "playSoundAttachedToElement", getPedOccupiedVehicle(player), "files/horns/"..tostring(getElementData(player, "usedHorn"))..".wav")
				end
			end
			setTimer( function(player) hornTime[player] = false end, 3000, 1, player)
		end
	end)
	
	bindKey(source, "g", "down", "chatbox", "Global" )
	bindKey(source, "x", "down", "chatbox", "GTeam" )		
	bindKey(source, "l", "down", "chatbox", "Lang" )
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)

function playerRequestInitialise()
	local allTheMaps = {}
	local resourceTable = getResources()
    for resourceKey, resourceValue in ipairs(resourceTable) do
        local name = getResourceName ( resourceValue )
		local maptype = getResourceInfo ( resourceValue, "type" )
		local mapname = getResourceInfo ( resourceValue, "name")
		if not mapname then mapname = name end
		if name then
			if maptype == "map" then
				allTheMaps[#allTheMaps+1] = {}
				allTheMaps[#allTheMaps].name = name
				allTheMaps[#allTheMaps].realname = mapname
			end
		end
	end	
	triggerLatentClientEvent ( source, "priorReceiveAllTheMaps", 50000, getRootElement(), allTheMaps )
end
addEvent("onPlayerRequestInitialise", true)
addEventHandler("onPlayerRequestInitialise", getRootElement(), playerRequestInitialise)

function resourceStart()
	setWaterLevel(0.01)
	setFPSLimit(55)
	setCloudsEnabled(false)
	for i,v in pairs(getElementsByType("player")) do
		triggerEvent ( "onPlayerJoin", v )
	end
	
	for i,v in ipairs(gRaceModes) do
		refreshVitaMaps(i)
		pLogger[i] = Logger.create("logs/"..v.name..".log")
		if getResourceFromName(v.res) then
			deleteResource(v.res)
		end
	end
	
	langLogger = {}
	for i,v in ipairs(gSupportedLanguages) do
		langLogger[i] = Logger.create("logs/lang/"..v..".log")
	end	
	
	
end
addEventHandler("onResourceStart", resourceRoot, resourceStart)

function resourceStop()
	for i,v in pairs(getElementsByType("player")) do
		triggerEvent ( "onPlayerQuit", v, "Restart" )
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), resourceStop)

function sendModesToClient(player)
	--Send the maps for mapsettings or buying to the client
	triggerClientEvent ( player, "startSelection", getRootElement(), gRaceModes )
	bindKey( player, "F3", "down", putPlayerBackToSelection)
end	
addEvent("sendModesToClient", true)
addEventHandler("sendModesToClient", getRootElement(), sendModesToClient)

function putPlayerBackToSelection(player)
	if getPlayerGameMode(player) == 0 then return false end
	triggerClientEvent ( player, "addNotification", getRootElement(), 2, 15,150,190, "You left '"..gRaceModes[getPlayerGameMode(player)].name.."'." )
	callServerFunction(gRaceModes[getPlayerGameMode(player)].quitfunc, player)
	triggerClientEvent ( player, "showSelection", getRootElement() )
	setElementData(player, "hackyMapBought", false)
end

function joinRP(player)
	if player then triggerClientEvent ( player, "addNotification", getRootElement(), 1, 200, 50, 50, "This gamemode is deactivated.") return false end
	triggerClientEvent ( player, "hideSelection", getRootElement() )
	triggerClientEvent ( player, "startSelectionRP", getRootElement() )
end
addEvent("joinRP", true)
addEventHandler("joinRP", getRootElement(), joinRP)

function redirectRP(player)
	redirectPlayer ( player, "mta.vita-online.eu", 22007 )
end
addEvent("redirectRP", true)
addEventHandler("redirectRP", getRootElement(), redirectRP)

function killPlayerRequest()
	if getPlayerGameMode(source) ~= 0 then
		callServerFunction(gRaceModes[getPlayerGameMode(source)].killfunc, source)
	end
end
addEvent("onRequestKillPlayer", true)
addEventHandler("onRequestKillPlayer", getRootElement(), killPlayerRequest)

function showWinMessage(gamemode, line1, line2, r, g, b)
	local players = getGamemodePlayers(gamemode)
	for _,player in pairs(players) do
		setElementData(player, "winline", line1)
		setElementData(player, "winline2", line2)
		setElementData(player, "winr", r)
		setElementData(player, "wing", g)
		setElementData(player, "winb", b)
	end
	setTimer( function()
		for theKey,player in ipairs(getGamemodePlayers(gamemode)) do
			setElementData(player, "winline", nil)
			setElementData(player, "winline2", nil)
			setElementData(player, "winr", nil)
			setElementData(player, "wing", nil)
			setElementData(player, "winb", nil)
		end
	end, 5000, 1 )
end

local restartTimer = nil
local timerElement = createElement("restartTimer")

function checkUsers()
	local currentOnlinePlayers = 0
	local players = getElementsByType("player")
	for _,player in pairs(players) do
		currentOnlinePlayers = currentOnlinePlayers +1
	end
	
	local realtime = getRealTime()
	local second = realtime.second
	local hours = realtime.hour
	local minutes = realtime.minute	
	if second == 0 and hours == 3 and minutes == 55 then
		restartTimer = setTimer ( shutdown, 1000*60*5, 1, "Server-Restart" )
		setElementData(timerElement, "left", 1000*60*5)
	end
	
	if restartTimer and isTimer(restartTimer) then
		local left, _, _ = getTimerDetails(restartTimer)
		setElementData(timerElement, "left", left)
	end
	
	local players = getElementsByType("player")
	for _,player in pairs(players) do
		--if tostring(getElementData(player, "country")) == "false" or tostring(getElementData(player, "country")) == "Unknown" then
		--	setElementData(player, "country", getPlayerCountry ( player ))
	--	end
		
		--isSpectatingMe(player)
	setElementData(player, "isMuted", isPlayerMuted(player))
		
	if getElementData(player, "AFK")  == true and getElementData(player, "state") == "alive" and getPlayerGameMode(player) ~= 3 then		
		callServerFunction(gRaceModes[getPlayerGameMode(player)].killfunc, player)
	end
	
	if getElementData(player, "playerMeme") ~= 0 and (getElementData(player, "memeActivated") == 1 or getElementData(player, "isDonator") == true) then
		addPlayerArchivement(player, 5)
	end
		
	if getElementData(player, "isDonator") == true then
		addPlayerArchivement(player, 45)
	end
		
	local playerTeam = getPlayerTeam( player )	
	if playerTeam then
		local rt, gt, bt = getTeamColor ( playerTeam )
		setBlipColor ( gPlayerBlips[player],rt,gt,bt,255 )
	end
	
	if getElementData(player, "FPS") then
			if (getElementData(player, "FPS")) == 0 then setElementData(player, "FPS", 16) end
			if tonumber(getElementData(player, "FPS")) < 15 and (getPlayerGameMode(player) == 1 or getPlayerGameMode(player) == 2) then --DD and SHOOTER
				if getElementData(player, "actionFPS") ~= true then
					setElementData(player, "actionFPS", true)
					setTimer(
						function(player)
							if tonumber(getElementData(player, "FPS")) < 15 and (getPlayerGameMode(player) == 1 or getPlayerGameMode(player) == 3)  and getElementData(player, "state") == "alive" then
								callServerFunction(gRaceModes[getPlayerGameMode(player)].killfunc, player)
							end
							setElementData(player, "actionFPS", false)
						end
					,5000,1, player)				
				end
			else
				setElementData(player, "actionFPS", false)
			end
		end
		
		if getPlayerPing ( player ) > 1000 then
			addPlayerArchivement( player, 18)
		end	
		if getPlayerPing ( player ) > 500 and (getPlayerGameMode(player) == 1 or getPlayerGameMode(player) == 2) then
			if getElementData(player, "actionPing") ~= true then
				setElementData(player, "actionPing", true)
				setTimer(
					function(player)
						if getPlayerPing ( player ) > 500 and (getPlayerGameMode(player) == 1 or getPlayerGameMode(player) == 2) and getElementData(player, "state") == "alive" then
							callServerFunction(gRaceModes[getPlayerGameMode(player)].killfunc, player)
						end
						setElementData(player, "actionPing", false)
					end
				,5000,1, player)				
			end
		else
			setElementData(player, "actionPing", false)
		end
		if isLoggedIn(player) == true then
		
			if math.floor(getElementData(player, "TimeOnServer")/60) >= 7200 then
				addPlayerArchivement(player, 15)
			end
			if math.floor(getElementData(player, "TimeOnServer")/60) >= 7200*2 then
				addPlayerArchivement(player, 16)
			end	
			
			setElementData(player, "WonMaps", getElementData(player, "DMWon")+getElementData(player, "DDWon")+getElementData(player, "SHWon")+getElementData(player, "RAWon"))
			setElementData(player, "PlayedMaps", getElementData(player, "DMMaps")+getElementData(player, "DDMaps")+getElementData(player, "SHMaps")+getElementData(player, "RAMaps"))
			setElementModel(player, getElementData(player, "Skin"))
			if string.find(getPlayerName(player), "Vita|") ~= nil then
				if getElementData(player, "Level")  == "User" then
					putPlayerBackToSelection(player)
					triggerClientEvent ( player, "addNotification", getRootElement(), 1, 255,0,0, "Remove the Vita| clantag." )
				else
					addPlayerArchivement(player, 40)
				end
			end
		
			if getElementData(player, "usedHorn") ~= 0 then
				toggleControl ( player, "horn", false )
			else
				toggleControl ( player, "horn", true )
			end

			if getPedOccupiedVehicle(player) and isElement(getPedOccupiedVehicle(player)) then
				if getElementData(player, "r1") and ((getElementData(player, "discoColor") ~= true and getElementData(player, "rainbowColor") ~= true) or getElementData(player, "isDonator") == false) then
					setVehicleColor(getPedOccupiedVehicle(player), getElementData(player, "r1"), getElementData(player, "g1"), getElementData(player, "b1"), getElementData(player, "r2"), getElementData(player, "g2"), getElementData(player, "b2"))
					setVehicleHeadLightColor ( getPedOccupiedVehicle(player), getElementData(player, "rl"), getElementData(player, "gl"), getElementData(player, "bl"))	
				end
				if getElementData(player, "Wheels") and getElementData(player, "Wheels") ~= 0 then
					addVehicleUpgrade ( getPedOccupiedVehicle(player), getElementData(player, "Wheels") )
				end				
			end
			local neededScore = tonumber(getElementData(player, "Rank")) * 50 * tonumber(getElementData(player, "Rank"))
			local lastScore = (tonumber(getElementData(player, "Rank"))-1) * 50 * (tonumber(getElementData(player, "Rank"))-1)
			if neededScore <= getElementData(player, "Points") then
				setElementData(player, "Rank", getElementData(player, "Rank") + 1)
				if tostring(getElementData(player, "Rank")) ~= "1" then
					if getElementData(player, "Rank") >= 69 then
						addPlayerArchivement(player, 69)
					end
					outputChatBoxToGamemode ( "#66CCFF:LEVEL: #FFFFFF"..getPlayerName(player).."#FFFFFF leveled up to level #FF0000"..getElementData(player, "Rank").."#FFFFFF.", getElementData(player, "gameMode"), 0, 255, 0, true )
				end
			end
			
			setElementData(getElementData(player, "accElement"), "Points", getElementData(player, "Points"))
			if getPlayerGameMode(player) then
				if #getGamemodePlayers(getPlayerGameMode(player)) >= 32 then
					addPlayerArchivement(player, 42)
				end
			end
		
			local veh = getPedOccupiedVehicle(player)
			if veh == false and isElement(getElementData(player, "raceVeh")) and getElementType ( getElementData(player, "raceVeh") ) == "vehicle" then
				warpPedIntoVehicle ( player, getElementData(player, "raceVeh") )
				setElementDimension(getElementData(player, "raceVeh"), getElementDimension(player))
			end
			
			setElementData(player, "lastScore", lastScore)
			setElementData(player, "neededScore", neededScore)
			
			syncArchivmentTableForPlayer(player)
		end
	end
end
setTimer ( checkUsers, 1000, 0 )

function discoColor()
	local players = getElementsByType("player")
	for _,player in pairs(players) do
		if getPedOccupiedVehicle(player) and isElement(getPedOccupiedVehicle(player)) then
			if getElementData(player, "discoColor") == true and getElementData(player, "isDonator") == true and getElementData(player, "rainbowColor") ~= true then
				setVehicleColor(getPedOccupiedVehicle(player), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255), math.random(0,255))
				setVehicleHeadLightColor ( getPedOccupiedVehicle(player), math.random(0,255), math.random(0,255), math.random(0,255))							
			end			
		end	
	end
end
setTimer(discoColor, 300, 0)

function getMapNameByRealName(realName)
	local resourceTable = getResources()
	for i,v in ipairs(resourceTable) do
		local name = getResourceName ( v )
		local mapnameinfo = getResourceInfo ( v, "name")
		local maptype = getResourceInfo ( v, "type" )
		if realName and mapnameinfo and maptype == "map" then
			if string.find(string.upper(tostring(mapnameinfo)), string.upper(tostring(realName))) then
				return name
			end
		end
	end
	return false
end

function setNextMap(id, mapname)
	local gameModeElement = getGamemodeElement(id)
	if getElementData(gameModeElement, "map") ~= "none" and getElementData(gameModeElement, "map") ~= "random" then
		local resource = getResourceFromName ( mapname )
		if resource then
			local maptype = getResourceInfo ( resource, "type" )
			if string.find (string.upper (mapname), "%["..gRaceModes[id].prefix.."%]") ~= nil and maptype == "map" then
				local metaXML = xmlLoadFile ( ":"..mapname.."/meta.xml" )
				if metaXML then
					setElementData(gameModeElement, "nextmap", mapname)
				
					local xmlInfo= xmlFindChild ( metaXML, "info", 0)
					if xmlInfo then 
						local realMapname = xmlNodeGetAttribute(xmlInfo, "name")
						if realMapname then
							setElementData(gameModeElement, "nextmapname", realMapname)
						else
							setElementData(gameModeElement, "nextmapname", mapname)
						end
					else
						setElementData(gameModeElement, "nextmapname", mapname)
					end			
					xmlUnloadFile(metaXML)
					return true
				end
			end
		end
	end
	return false
end

function refreshVitaMaps(gamemodeID)
	local localMaps = {}
	--local prefix = "%["..gRaceModes[gamemodeID].prefix.."%]"
	local prefix = gRaceModes[gamemodeID].prefix

	local resourceTable = getResources()
	for resourceKey, resourceValue in ipairs(resourceTable) do
		local name = getResourceName ( resourceValue )
		local maptype = getResourceInfo ( resourceValue, "type" )
		if string.find (string.upper (name), prefix) ~= nil and maptype == "map" then
			localMaps[#localMaps+1] = {}
			localMaps[#localMaps].name = name
		end			
	end
	gRaceModes[gamemodeID].maps = localMaps
end

function refreshMapsCMD()
	--Todo: Rename command (this is a hardcoded mta command)
	--Todo: Check admin state, refresh resources, refreshVitaMaps (don't forget gamemodeID)
end
addCommandHandler("refresh", refreshMapsCMD)

function getRandomMap(gamemodeID)
	if #gRaceModes[gamemodeID].maps == 0 then
		refreshVitaMaps(gamemodeID)
		return getRandomMap(gamemodeID)
	end
	
	local number = math.random(1, #gRaceModes[gamemodeID].maps)
	local name = gRaceModes[gamemodeID].maps[number].name
	table.remove(gRaceModes[gamemodeID].maps, number)
	
	return name
end

function syncVehicleNitro()
	local veh = getPedOccupiedVehicle(source)
	if not veh then return false end
	for i,v in pairs(getGamemodePlayers(getPlayerGameMode(source))) do
		if v ~= source then
			callClientFunction(v, "addVehicleUpgrade", veh, 1010)
		end
	end
end	
addEvent("syncVehicleNitro", true)
addEventHandler("syncVehicleNitro", getRootElement(), syncVehicleNitro)

function syncVehicleModel(model)
	local veh = getPedOccupiedVehicle(source)
	if not veh then return false end
	setElementModel(veh, model)
end	
addEvent("syncVehicleModel", true)
addEventHandler("syncVehicleModel", getRootElement(), syncVehicleModel)

function calculateKm ( )
	for k, vehicle in ipairs(getElementsByType("vehicle")) do
		if getVehicleOccupant ( vehicle ) and isLoggedIn(getVehicleOccupant ( vehicle )) then
			local player = getVehicleOccupant ( vehicle )
			local vx, vy, vz = getElementVelocity ( vehicle )
			local speed =  math.floor(  ((vx^2 + vy^2 + vz^2) ^ 0.7) * 50 * 3.6 )
			local way = speed * 0.000277778
			setElementData(player, "KM", getElementData(player, "KM")+way)
			
			if getElementData(player, "KM") >= 10000 then
				addPlayerArchivement(player, 58)
			end
		end	
	end
end
setTimer(calculateKm, 1000, 0)

function nickChangeHandler(oldNick, newNick)
	if newNick == "false" then cancelEvent() return false end
	if getElementData(source, "renamelock") == true then
		outputChatBox ( "#FF0000:ERROR:#FFFFFF You can only rename yourself every minute.", source, 0, 255, 0, true )
		cancelEvent()
		return false
	end                      

	local accElements = getElementsByType ( "userAccount" )
	for theKey,accElement in ipairs(accElements) do
		if getElementData(accElement, "AccountName") == getElementData(source, "AccountName") then 
			if rollOldNick[source] then
				setElementData(accElement, "PlayerName", tostring(rollOldNick[source]))
			else
				setElementData(accElement, "PlayerName", _getPlayerName(source))
			end
		end  
	end

	outputChatBoxToGamemode ( "#FFD987:NICK: #FFFFFF"..oldNick.."#FFFFFF is now known as "..newNick.."#FFFFFF.", getPlayerGameMode(source), 0, 255, 0, true )
	addPlayerArchivement(source, 36)
	setElementData(source, "renamelock", true)
	setTimer ( function(source)
		setElementData(source, "renamelock", nil)
	end, 60000, 1, source )		 
	setPlayerNametagText ( source, removeColorCoding (newNick) )
end
addEventHandler("onPlayerChangeNick", getRootElement(), nickChangeHandler)


addEventHandler("onPlayerDamage", getRootElement(),
	function (attacker, weapon, bodypart, loss)
		if bodypart == 9 then
			callClientFunction(attacker, "playSound", "files/audio/headshot.mp3")
			addPlayerArchivement(attacker, 74)
			killPed(source, attacker, weapon, bodypart)
		end
	end
)


addEvent("requestLODsClient", true)
