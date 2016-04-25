--[[
Project: Vita Ware
File: game-getoff-server.lua
Author(s):	Sebihunter
]]--


local datMarkerOff = false

function startGetOffGame()
	datMarkerOff = createMarker ( 259.3999023438,359.1000976563,55, "checkpoint", 45, 0,0,0,0 )
	setElementDimension(datMarkerOff, 4)
	setElementDimension(wareArenaObjectWalls, gGamemodeFUN+100)
	moveObject (  wareArenaObjectBottom, 5000,259.3999023438, 359.1000976563, 57.29999923706,0,0,1024, "InOutQuad")
	for i,v in ipairs(wareWallCollision) do
		setElementDimension(v, gGamemodeFUN+100)
	end

	
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Get off the plattform!")	
		setElementData(player, "wareWon", false)
	end
	
end

function endGetOffGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if isElementWithinMarker ( player, datMarkerOff ) == false then
			setElementData(player, "wareWon", true)
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
		local x = math.random(-20,20)
		local y = math.random(-20,20)
		spawnPlayer(player, 259.3999023438+x, 359.1000976563+y, 56+2,0,getElementData(player, "Skin"))
		setElementDimension(player, gGamemodeFUN)
		fadeCamera(player, true)
		setCameraTarget(player, player)							
	end	
	setElementDimension(wareArenaObjectWalls, gGamemodeFUN)
	for i,v in ipairs(wareWallCollision) do
		setElementDimension(v, gGamemodeFUN)
	end		
	if isElement(datMarkerOff) then destroyElement(datMarkerOff) end
end

