--[[
Project: vitaCore
File: gg-core.lua
Author(s):	Sebihunter
]]--

local funRGTimers = {}
local funRGObjects = {}
local rgTextTimer = {}

local rgArena = {}
local rgSpawn = {}
local rgFinish = {}
local rgSaves = {}
local rgBlip = false
local rgWonPlayers = {}

local rgMapname = "None"
local rgCheckpoint = false
local hasSomebodyAlreadyWon = false
local rgRankingboard = {}

local mapsRG = {
 [1] = { name = "[RUN] Corby - J!zzb3rt", arena = rgArenaJizz, spawn = rgSpawnJizz, finish = rgFinishJizz}
}

function showRGText(player, text)
	if rgTextTimer[player] and isTimer(rgTextTimer[player]) then killTimer(rgTextTimer[player]) end
	setElementData(player, "rgText", text)
	rgTextTimer[player] = setTimer(function(player)
		setElementData(player, "rgText", false)
	end, 5000, 1, player)
end

function spawnFunctRG ( passedPlayer )
	if isElement(passedPlayer) == false or getElementData(passedPlayer, "gameMode") ~= gGamemodeFUN then return end
	spawnPlayer(passedPlayer, rgSpawn.posX, rgSpawn.posY, rgSpawn.posZ,rgSpawn.rotZ,getElementData(passedPlayer, "Skin"))
	setElementDimension(passedPlayer, gGamemodeFUN)
	setCameraTarget(passedPlayer, passedPlayer)
	setElementData(passedPlayer, "state", "alive")	
end


function playerJoinRG ( player )
	rgSaves[player] = nil
	fadeCamera ( player, true )
	setElementData(player, "rgText", false)
	setPlayerNametagShowing ( player, true )
	
	showRGText(player, "Welcome to "..rgMapname..":\nGet to the checkpoint to win this map.\nUse /sp and /lp to save and load your position.")
	outputChatBox ("#009029:RUNNING MEN:#ffffff Use /sp and /lp to save and load your position.", player, 255, 255, 255, true)
	setElementData(player, "mapname", "Running Men - "..rgMapname)
	callClientFunction(player, "showGUIComponents", "mapdisplay", "money")
	callClientFunction(player, "RGClient", true)
	setElementData(player, "gBlockCarfade", true)
	spawnFunctRG ( player )	
	if isElement(rgBlip) then
		setElementVisibleTo(rgBlip, player, true)
	end
end

function quitFunRG(player)
	callClientFunction(player, "RGClient", false)
	setElementData(player, "gBlockCarfade", false)
	callClientFunction(player, "hideGUIComponents", "mapdisplay", "money")
	setPlayerNametagShowing ( player, false )
	if isElement(rgBlip) then
		setElementVisibleTo(rgBlip, player, false)
	end	
end

function playerWastedRG (  player, source, weapon )
	funRGTimers[#funRGTimers+1] = setTimer ( spawnFunctRG, 5000, 1, player )
	setElementData(player, "state", "dead")
	showRGText(player, "You've died.\nUse /sp and /lp to save and load your position.")
end

function endFunRG()
	for i, element in ipairs(rgArena) do
		setElementDimension(element, gGamemodeFUN+100)
	end
	for i,v in ipairs(funRGObjects) do
		if isElement(v) then destroyElement(v) end
	end
	for i,v in ipairs(funRGTimers) do
		if isTimer(v) then killTimer(v) end
	end	
	for i,v in ipairs(rgTextTimer) do
		if isTimer(v) then killTimer(v) end
	end		
	
	destroyElement(markerHit)
	destroyElement(rgBlip)	
	setElementData(gElementFUN, "rankingboard", hayRankingboard)
	hasSomebodyAlreadyWon = false
	
	removeCommandHandler("lp")
	removeCommandHandler("sp")
end

function startFunRG ( )
	local randNumber = math.random(1,#mapsRG)
	rgSaves = {}
	rgArena = mapsRG[randNumber].arena
	rgSpawn = mapsRG[randNumber].spawn
	rgFinish = mapsRG[randNumber].finish
	rgMapname =  mapsRG[randNumber].name
	rgCheckpoint = createMarker(rgFinish.posX, rgFinish.posY, rgFinish.posZ, "checkpoint", 4, 255,0,0,255)
	rgBlip = createBlip ( rgFinish.posX, rgFinish.posY, rgFinish.posZ, 0, 2, 255,0,0,255)
	setElementData(gElementFUN , "mapname", "Running Men - "..rgMapname)
	setElementData(rgBlip, "doDraw", true)
	setElementVisibleTo(rgBlip, getRootElement(), false)
	setElementDimension(rgCheckpoint, gGamemodeFUN)
	hasSomebodyAlreadyWon = false
	rgWonPlayers = {}
	rgRankingboard = {}

	addCommandHandler ( "sp", function (player)
		if getElementData(player, "gameMode") == gGamemodeFUN and isPlayerAlive(player) then
			local px,py,pz = getElementPosition(player)
			local _, _, rz = getElementRotation(player)
			rgSaves[player] = {x = px, y = py, z = pz, rz = rz}
			showRGText(player, "Position saved.")
			addPlayerArchivement(player, 71)
		end
	end	)
	
	addCommandHandler ( "lp", function (player)
		if getElementData(player, "gameMode") == gGamemodeFUN and isPlayerAlive(player) then
			if rgSaves[player] then
				setElementPosition(player, rgSaves[player].x, rgSaves[player].y,rgSaves[player].z)
				setElementRotation(player, 0,0,0, rgSaves[player].rz)
				showRGText(player, "Teleported to saved position.")
			else
				showRGText(player, "No position saved.")
			end
		end
	end	)
	
	addEventHandler("onPlayerMarkerHit",getRootElement(),function(markerHit,matchingDimension)
		if (matchingDimension) and rgCheckpoint == markerHit then
			for i,v in ipairs(rgWonPlayers) do
				if v == source then return end
			end
			addPlayerArchivement(source, 70)
			rgWonPlayers[#rgWonPlayers+1] = source
			rgRankingboard[#rgRankingboard+1] = {}
			rgRankingboard[#rgRankingboard].player = source
			rgRankingboard[#rgRankingboard].text = _getPlayerName(source)
			setElementData(gElementFUN, "rankingboard", rgRankingboard)
			if hasSomebodyAlreadyWon == true then 
				setElementData(source, "Points", getElementData(source, "Points") + 30*#getGamemodePlayers(gGamemodeFUN))
				if getElementData(source, "isDonator") == true then 
					setElementData(source, "Money", getElementData(source, "Money") + 250*#getGamemodePlayers(gGamemodeFUN))			
					outputChatBox("#996633:Points: #ffffff You received "..tostring(30*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(250*#getGamemodePlayers(gGamemodeFUN)).." Vero for completing this mode.", source, 255, 255, 255, true)	
				else
					setElementData(source, "Money", getElementData(source, "Money") + 125*#getGamemodePlayers(gGamemodeFUN))			
					outputChatBox("#996633:Points: #ffffff You received "..tostring(30*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(125*#getGamemodePlayers(gGamemodeFUN)).." Vero for completing this mode.", source, 255, 255, 255, true)					
				end
				return
			end		
			hasSomebodyAlreadyWon = true
			setElementData(source, "Points", getElementData(source, "Points") + 50*#getGamemodePlayers(gGamemodeFUN))
			if getElementData(source, "isDonator") == true then 
				setElementData(source, "Money", getElementData(source, "Money") + 400*#getGamemodePlayers(gGamemodeFUN))			
				outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(400*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", source, 255, 255, 255, true)
			else
				setElementData(source, "Money", getElementData(source, "Money") + 200*#getGamemodePlayers(gGamemodeFUN))			
				outputChatBox("#996633:Points: #ffffff You received "..tostring(50*#getGamemodePlayers(gGamemodeFUN)).." points and "..tostring(200*#getGamemodePlayers(gGamemodeFUN)).." Vero for winning this mode.", source, 255, 255, 255, true)		
			end
			
			if getElementData(source, "isDonator") == true then
				if getElementData(source, "useWinsound") ~= 0 then
					local players = getGamemodePlayers(gGamemodeFUN)
					for theKey,thePlayer in ipairs(players) do
						if getElementData(thePlayer, "toggleWinsounds") == 1 then
							triggerClientEvent(thePlayer, "playWinsound", getRootElement(), "files/winsounds/"..tostring(getElementData(source, "useWinsound"))..".mp3")
						end
					end
				end
			end
			
			if getElementData(source, "customWintext") ~= "none" and getElementData(source, "isDonator") == true then
				showWinMessage(gGamemodeFUN, "#FFFFFF"..tostring(getElementData(source, "customWintext")), "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			else
				showWinMessage(gGamemodeFUN, "#FFFFFF".._getPlayerName(source) .. '#FFFFFF has won Running Men!', "#FFFFFFThe mode will end in 15 seconds.", 214, 219, 145)
			end
			funRGTimers[#funRGTimers+1] = setTimer(function()
				unloadModeFUN()
				startVoteFUN()
			end, 15000, 1)			
		end		
	end)
	
	for i, element in ipairs(rgArena) do
		setElementDimension(element, gGamemodeFUN)
	end
end


