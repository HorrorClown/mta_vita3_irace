--[[
Project: vitaCore
File: su-core.lua
Author(s):	Sebihunter
]]--

local funSUTimers = {}
local funSUObjects = {}
local suTextTimer = {}

local suArena = {}
local suSpawns = {}

local suHasWinner = false
local suMapname = "None"
local hasSomebodyAlreadyWon = false
local sumoEndTimer = false
local suMusic = false
local suTextures = false
local suHour = false
local suWaterLevel = 0

local blockCars = { 403, 406, 407, 408, 427, 428, 431, 433, 437, 443, 444, 456, 486, 514, 515, 524, 528, 532, 544, 556, 601, 573, 578, 588 }

local suCars ={
400,402,403,404,406,407,408,409,411,412,413,414,415,416,
420,423,424,427,428,429,431,433,434,437,438,439,442,443,
444,451,455,456,466,470,471,475,480,545,604,531,478,574,
482,486,489,490,494,495,500,502,503,504,505,506,514,515,
524,528,532,534,535,541,542,544,549,555,556,549,601,571,
560,561,562,565,568,573,578,579,588,596,597,598,599,603}

local mapsSU = {
 [1] = { name = "[SU] Simple", arena = suArenaSimple, spawns = suSpawnsSimple, music = "http://sebihunter.de/serverfiles/race/sumo-simple.mp3"},
 [2] = { name = "[SU] Artjom - 4 on 1", arena = suArena4on1, spawns = suSpawns4on1, music = "http://sebihunter.de/serverfiles/race/goat.mp3", textures = suTexturs4on1, hour = 2, water = 5},
 [3] = { name = "[SU] Corby - Jizzy Haggar", arena = suArenaJizzy, spawns = suSpawnsJizzy, music = "http://sebihunter.de/serverfiles/race/su-jizzy.mp3", textures = suTextursJizzy, hour = 2},
 [4] = { name = "[SU] Radion - Infinity", arena = suArenaInfinity, spawns = suSpawnsInfinity, music = "http://sebihunter.de/serverfiles/race/music-infinity.mp3"}
}
function showSUText(player, text)
	if suTextTimer[player] and isTimer(suTextTimer[player]) then killTimer(suTextTimer[player]) end
	setElementData(player, "suText", text)
	suTextTimer[player] = setTimer(function(player)
		setElementData(player, "suText", false)
	end, 5000, 1, player)
end

function spawnFunctSU ( passedPlayer )
	if isElement(passedPlayer) == false or getElementData(passedPlayer, "gameMode") ~= gGamemodeFUN then return end
	if isElement(getElementData(passedPlayer, "suVeh")) then destroyElement(getElementData(player, "suVeh")) end
	
	local suCar = suCars[math.random(1,#suCars)]
	if #getGamemodePlayers(gGamemodeFUN) <= 5 then
		for i,v in ipairs(blockCars) do
			if suCar == v then return spawnFunctSU ( passedPlayer ) end
		end
	end
	
	local _, left, _ =  getTimerDetails ( sumoEndTimer )
	if left < 180 then
		setElementData(passedPlayer, "state", "dead")
		setCameraMatrix ( passedPlayer, suSpawns[1].posX,suSpawns[1].posY,suSpawns[1].posZ+100 ,suSpawns[1].posX,suSpawns[1].posY,suSpawns[1].posZ )
		exports.freecam:setPlayerFreecamEnabled (passedPlayer)
		showSUText(passedPlayer, "Spectating:\nSUDDEN DEATH - LAST ALIVE WINS")
		return
	end	
	
	spawnPlayer(passedPlayer, suSpawns[randNumber].posX, suSpawns[randNumber].posY, suSpawns[randNumber].posZ,suSpawns[randNumber].rotZ,getElementData(passedPlayer, "Skin"))
	setElementDimension(passedPlayer, gGamemodeFUN)	
	local veh = createVehicle ( suCar, suSpawns[randNumber].posX, suSpawns[randNumber].posY, suSpawns[randNumber].posZ,0,0,suSpawns[randNumber].rotZ, "Vita" )
	setElementData(passedPlayer, "ghostmod", false)
	addEventHandler("onVehicleDamage", veh, onSUDamage)


	funSUTimers[#funSUTimers+1] = setTimer(function(player)
		if isElement(player) == false or getElementData(player, "gameMode") ~= gGamemodeFUN then return end
		local _, left, _ =  getTimerDetails ( getElementData(player, "suTimer") )
		setElementData(player, "suTimerTime", 181-left)
		if left == 1 then
			if #getGamemodePlayers(gGamemodeFUN) > 1 then
				addPlayerArchivement(player, 72)
			end
			if hasSomebodyAlreadyWon == true then 
				setElementData(player, "Points", getElementData(player, "Points") + 30*#getGamemodePlayers(gGamemodeFUN))
				if getElementData(player, "isDonator") == true then 
					setElementData(player, "Money", getElementData(player, "Money") + 250*#getGamemodePlayers(gGamemodeFUN))		
					outputChatBox("#996633:Points: #ffffff You received "..tostring(30*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(250*#getGamemodePlayers(gGamemodeFUN)).." Vero for completing this mode.", player, 255, 255, 255, true)		
				else
					setElementData(player, "Money", getElementData(player, "Money") + 125*#getGamemodePlayers(gGamemodeFUN))		
					outputChatBox("#996633:Points: #ffffff You received "..tostring(30*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(125*#getGamemodePlayers(gGamemodeFUN)).." Vero for completing this mode.", player, 255, 255, 255, true)						
				end
				return
			end
			hasSomebodyAlreadyWon = true
			if #getGamemodePlayers(gGamemodeFUN) > 1 then
				setElementData(player, "Points", getElementData(player, "Points") + 50*#getGamemodePlayers(gGamemodeFUN))
				if getElementData(player, "isDonator") == true then 
					setElementData(player, "Money", getElementData(player, "Money") + 400*#getGamemodePlayers(gGamemodeFUN))			
					outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(400*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", player, 255, 255, 255, true)
				else
					setElementData(player, "Money", getElementData(player, "Money") + 200*#getGamemodePlayers(gGamemodeFUN))			
					outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(200*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", player, 255, 255, 255, true)				
				end
			end
			
			if getElementData(player, "isDonator") == true then
				if getElementData(player, "useWinsound") ~= 0 then
					local players = getGamemodePlayers(gGamemodeFUN)
					for theKey,thePlayer in ipairs(players) do
						if getElementData(thePlayer, "toggleWinsounds") == 1 then
							triggerClientEvent(thePlayer, "playWinsound", getRootElement(), "files/winsounds/"..tostring(getElementData(player, "useWinsound"))..".mp3")
						end
					end
				end
			end
			
			if getElementData(player, "customWintext") ~= "none" and getElementData(player, "isDonator") == true then
				showWinMessage(gGamemodeFUN, "#FFFFFF"..tostring(getElementData(player, "customWintext")), "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			else
				showWinMessage(gGamemodeFUN, "#FFFFFF".._getPlayerName(player) .. '#FFFFFF has won Sumo!', "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			end
			funSUTimers[#funSUTimers+1] = setTimer(function()
				unloadModeFUN()
				startVoteFUN()
			end, 15000, 1)
		end
	end
	,1000,180,passedPlayer)

	setElementData(passedPlayer, "suTimer", funSUTimers[#funSUTimers])
	setElementAlpha ( veh, 150)
	
	for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		callClientFunction(v, "SUCollision", false, veh)
	end
	
	funSUTimers[#funSUTimers+1] = setTimer(function(veh)
		if isElement(veh) then
			setElementAlpha(veh, 255)
			removeEventHandler("onVehicleDamage", veh, onSUDamage)
			for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
				callClientFunction(v, "SUCollision", true, veh)
			end
		end
	end, 5000, 1, veh)
	
	setElementDimension(veh, gGamemodeFUN)
	warpPedIntoVehicle ( passedPlayer, veh )
	setElementData(passedPlayer, "suVeh", veh)
	setCameraTarget(passedPlayer, passedPlayer)
	setElementData(passedPlayer, "state", "alive")	
	setElementAlpha(passedPlayer,255) 
	
	local elem = createElement("sumoVeh")
	setElementData(elem, "veh", veh)
end

function onSUDamage(loss)
    fixVehicle ( source )
end
 
function playerJoinSU ( player )
	setElementData(v, "suTimerTime", 0)
	fadeCamera ( player, true )
	toggleControl ( player, "enter_exit", false )
	setElementData(player, "suLevel", 1)
	setElementData(player, "suText", false)
	showSUText(player, "Welcome to "..suMapname..":\nStay alive for 180 seconds.")
	setElementData(player, "mapname", "Sumo - "..suMapname)
	callClientFunction(player, "showGUIComponents", "mapdisplay", "money")
	callClientFunction(player, "setTime", tonumber(suHour), 0)
	callClientFunction(player, "setWaterLevel", tonumber(suWaterLevel))
	callClientFunction(player, "SUClient", true, suTextures)
	local _, left, _ =  getTimerDetails ( sumoEndTimer )
	setElementData(player, "suTimeLeft", left*1000)
	setCameraMatrix ( player, suSpawns[1].posX,suSpawns[1].posY,suSpawns[1].posZ+100 ,suSpawns[1].posX,suSpawns[1].posY,suSpawns[1].posZ )
	
	if suMusic then
		triggerClientEvent(player, "onMapSoundReceive", getRootElement(), tostring(suMusic))
	end
	funSUTimers[#funSUTimers+1] = setTimer ( spawnFunctSU, 5000, 1, player )
end

function quitFunSU(player)
	if isElement(getElementData(player, "suVeh")) then destroyElement(getElementData(player, "suVeh")) end
	if isTimer(getElementData(player, "suTimer")) then killTimer(getElementData(player, "suTimer")) end
	triggerClientEvent(player, "onMapSoundStop", getRootElement())		
	callClientFunction(player, "SUClient", false, suTextures)
	setElementData(player, "mapname", false)
	toggleControl ( player, "enter_exit", true )
	callClientFunction(player, "resetWaterLevel")
	setElementAlpha(player,255) 
	exports.freecam:setPlayerFreecamDisabled (player)
end

function playerWastedSU (  player )
	if isPedDead(player) == false then killPed(player) return end
	if isElement(getElementData(player, "suVeh")) then destroyElement(getElementData(player, "suVeh")) end
	funSUTimers[#funSUTimers+1] = setTimer ( spawnFunctSU, 5000, 1, player )
	setElementData(player, "state", "dead")
	setElementAlpha(player,0) 
	if isTimer(getElementData(player, "suTimer")) then killTimer(getElementData(player, "suTimer")) end
	showSUText(player, "You've died.")
	
	local _, left, _ =  getTimerDetails ( sumoEndTimer )
	if left < 180 then
		local alive = 0
		local alivePlayer = false
		for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
			if getElementData(v, "state") == "alive" then
				alive = alive + 1
				alivePlayer = v
			end
		end
		if alive == 1 then
			if hasSomebodyAlreadyWon == true then return end
			setElementData(alivePlayer, "Points", getElementData(alivePlayer, "Points") + 50*#getGamemodePlayers(gGamemodeFUN))
			setElementData(alivePlayer, "Money", getElementData(alivePlayer, "Money") + 200*#getGamemodePlayers(gGamemodeFUN))			
			outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(200*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", alivePlayer, 255, 255, 255, true)
			
			if getElementData(alivePlayer, "isDonator") == true then
				if getElementData(alivePlayer, "useWinsound") ~= 0 then
					local players = getGamemodePlayers(gGamemodeFUN)
					for theKey,thePlayer in ipairs(players) do
						if getElementData(thePlayer, "toggleWinsounds") == 1 then
							triggerClientEvent(thePlayer, "playWinsound", getRootElement(), "files/winsounds/"..tostring(getElementData(alivePlayer, "useWinsound"))..".mp3")
						end
					end
				end
			end
			
			if getElementData(alivePlayer, "customWintext") ~= "none" and getElementData(alivePlayer, "isDonator") == true then
				showWinMessage(gGamemodeFUN, "#FFFFFF"..tostring(getElementData(alivePlayer, "customWintext")), "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			else
				showWinMessage(gGamemodeFUN, "#FFFFFF".._getPlayerName(alivePlayer) .. '#FFFFFF has won Sumo!', "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			end
			
			if isTimer(sumoEndTimer) then killTimer(sumoEndTimer) end
			setElementData(gElementFUN, "rankingboard", {})
			
			funSUTimers[#funSUTimers+1] = setTimer(function()
				local _, left, _ =  getTimerDetails ( sumoEndTimer )
				for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
					setElementData(v, "suTimeLeft", left*1000)
				end
				for i,v in ipairs(getElementsByType("sumoVeh")) do
					if isElement(getElementData(v, "veh")) then
						if getVehicleOccupant ( getElementData(v, "veh") ) == false then
							destroyElement(getElementData(v, "veh"))
							destroyElement(v)
						end
					else
						destroyElement(v)
					end	
				end				
				if left == 1 then
					unloadModeFUN()
					startVoteFUN()
				end
			end, 1000, 15-1)
			sumoEndTimer = funSUTimers[#funSUTimers]
		elseif alive == 0 then
			setElementData(gElementFUN, "rankingboard", {})
			unloadModeFUN()
			startVoteFUN()		
		end
	end
end


function endFunSU()
	for i, element in ipairs(suArena) do
		setElementDimension(element, gGamemodeFUN+100)
	end
	for i,v in ipairs(funSUObjects) do
		if isElement(v) then destroyElement(v) end
	end
	for i,v in ipairs(funSUTimers) do
		if isTimer(v) then killTimer(v) end
	end	
	for i,v in ipairs(suTextTimer) do
		if isTimer(v) then killTimer(v) end
	end		
	setElementData(gElementFUN, "rankingboard", {})
	
	for i,v in ipairs(getElementsByType("sumoVeh")) do
		if isElement(getElementData(v, "veh")) then destroyElement(getElementData(v, "veh")) end
		destroyElement(v)
	end
end

function startFunSU ( )
	setElementData(gElementFUN, "rankingboard", {})
	randNumber = 1
	--local randNumber = math.random(1,#mapsSU)
	suArena = mapsSU[randNumber].arena
	suSpawns = mapsSU[randNumber].spawns
	suMapname =  mapsSU[randNumber].name
	if mapsSU[randNumber].music then
		suMusic = mapsSU[randNumber].music
	else
		suMusic = false
	end
	
	if mapsSU[randNumber].hour then suHour = mapsSU[randNumber].hour else suHour = 12 end
	if mapsSU[randNumber].water then suWaterLevel = mapsSU[randNumber].water else suWaterLevel = 0 end
	
	if mapsSU[randNumber].textures then
		suTextures = mapsSU[randNumber].textures
	else
		suTextures = false
	end
		
	suHasWinner = false
	hasSomebodyAlreadyWon = false
	setElementData(gElementFUN , "mapname", "Sumo - "..suMapname)
	funSUTimers[#funSUTimers+1] = setTimer(function()
		local _, left, _ =  getTimerDetails ( sumoEndTimer )
		for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
			setElementData(v, "suTimeLeft", left*1000)
			if left == 180 then
				showSUText(v, "WARNING: 180 seconds left\nSUDDEN DEATH - LAST ALIVE WINS")
			end
		end
	
		local myTable = {}
		for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
			myTable[#myTable+1] = {}
			myTable[#myTable].player = source
			local st = getElementData(v, "suTimerTime")
			if st > 120 then
				myTable[#myTable].text = _getPlayerName(v).."#FF0000 ("..getElementData(v, "suTimerTime")..")"
			elseif st > 60 then
				myTable[#myTable].text = _getPlayerName(v).."#FFFF00 ("..getElementData(v, "suTimerTime")..")"
			else
				myTable[#myTable].text = _getPlayerName(v).."#00FF00 ("..getElementData(v, "suTimerTime")..")"
			end
			myTable[#myTable].left = getElementData(v, "suTimerTime")
		end
		
		table.sort(myTable, 
			function(a, b)
				return a.left > b.left
			end
		)
		setElementData(gElementFUN, "rankingboard", myTable)	

	
		for i,v in ipairs(getElementsByType("sumoVeh")) do
			if isElement(getElementData(v, "veh")) then
				if getVehicleOccupant ( getElementData(v, "veh") ) == false then
					destroyElement(getElementData(v, "veh"))
					destroyElement(v)
				end
			else
				destroyElement(v)
			end	
		end
				
		if left == 1 then
			local leftPlayers = {}
			for i,v in ipairs(getGamemodePlayers(gGamemodeFUN)) do
				if getElementData(v, "state") == "alive" then
					local _, left2, _ =  getTimerDetails ( getElementData(v, "suTimer") )
					if left2 then
						leftPlayers[#leftPlayers+1] = {}
						leftPlayers[#leftPlayers].player = v
						leftPlayers[#leftPlayers].score = left2
					end
				end
			end
			table.sort(leftPlayers,
			function(a, b)
				return a.score > b.score
			end
			)	
			
			if isElement(leftPlayers[1].player) then
				setElementData(leftPlayers[1].player, "Points", getElementData(leftPlayers[1], "Points") + 50*#getGamemodePlayers(gGamemodeFUN))
				setElementData(leftPlayers[1].player, "Money", getElementData(leftPlayers[1], "Money") + 200*#getGamemodePlayers(gGamemodeFUN))			
				outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(200*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", leftPlayers[1].player, 255, 255, 255, true)				
			end
			
			unloadModeFUN()
			startVoteFUN()
		end
	end, 1000, 60*15-1)
	sumoEndTimer = funSUTimers[#funSUTimers]
	
	for i, element in ipairs(suArena) do
		setElementDimension(element, gGamemodeFUN)
	end
end


