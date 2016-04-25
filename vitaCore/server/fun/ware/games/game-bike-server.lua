--[[
Project: Vita Ware
File: game-bike-server.lua
Author(s):	Sebihunter
]]--


local bikePickups = {}

function startBikeGame()
	bikePickups = {}
	for i=1, math.round(#getGamemodePlayers(gGamemodeFUN)/2, 0, "ceil"), 1 do
		local x = math.random(-25,25)
		local y = math.random(-25,25)	
		local veh = createVehicle ( 481, 259.3999023438+x,359.1000976563+y,60)
		setElementDimension(veh,4)	
		bikePickups[#bikePickups+1] = veh
	end
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Nigger stole my bike!")
		triggerClientEvent(player, "onMapSoundReceive", getRootElement(), "files/audio/nigga_bike.mp3")		
	end
end

function endBikeGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		triggerClientEvent(player, "onMapSoundStop", getRootElement())		
		if isPedInVehicle ( player ) then setElementData(player, "wareWon", true) end
		if getElementData(player, "wareWon") == true then
			if getElementModel(player) == 0 then
				addPlayerArchivement(player, 66)
			end
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end	
	for i, pickup in ipairs(bikePickups) do
		destroyElement(bikePickups[i])
	end
end