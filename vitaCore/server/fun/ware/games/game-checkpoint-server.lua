--[[
Project: vitaCore
File: game-checkpoint-server.lua
Author(s):	Sebihunter
]]--

local checkpointGameMarker = nil

function startCheckpointGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Get into the checkpoint!")
	end
	local x = math.random(-20,20)
	local y = math.random(-20,20)
	checkpointGameMarker = createMarker ( 259.3999023438+x, 359.1000976563+y, 54, "cylinder", 5, 0, 150, 0, 125 )
	setElementDimension(checkpointGameMarker, gGamemodeFUN)
	addEventHandler( "onMarkerHit", checkpointGameMarker, onCheckpointGameHit )
	addEventHandler( "onMarkerLeave", checkpointGameMarker, onCheckpointGameLeave )
end

function endCheckpointGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
	removeEventHandler( "onMarkerHit",checkpointGameMarker, onCheckpointGameHit )
	removeEventHandler( "onMarkerLeave", checkpointGameMarker, onCheckpointGameLeave )
	destroyElement(checkpointGameMarker)
	checkpointGameMarker = nil
end

function onCheckpointGameHit (hitElement, matchingDimension)
	local randomNumber = math.random(1,3)
	setElementData(hitElement, "wareWon", true)
	callClientFunction(hitElement, "playSound", "./files/audio/ware/local_exo_won"..tostring(randomNumber)..".wav" )
end

function onCheckpointGameLeave (hitElement, matchingDimension)
	setElementData(hitElement, "wareWon", false)
end