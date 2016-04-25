--[[
Project: Vita Ware
File: game-Bomb-server.lua
Author(s):	Sebihunter
]]--


local datBomb = false
local datMarkerBomb = false
local bx
local by

function startBombGame()
	BombPickups = {}
	bx = math.random(-25,25)
	by = math.random(-25,25)	
	datBomb = createObject ( 1252, 259.3999023438+bx,359.1000976563+by,55)	
	setElementDimension(datBomb, 4)
	datMarkerBomb = createMarker ( 259.3999023438+bx,359.1000976563+by,55, "arrow", 1, 255,0,0,255 )
	setMarkerColor ( datMarkerBomb, 255, 0, 0, 255 )      
	setMarkerType ( datMarkerBomb, "arrow" )
	setElementDimension(datMarkerBomb, 4)

	
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Avoid the Bomb!")	
		setElementData(player, "wareWon", true)
	end
	
	setTimer(function() createExplosion(259.3999023438+bx,359.1000976563+by,55,6)  createExplosion(259.3999023438+bx,359.1000976563+by,55,6) end,4000,1)
	addEventHandler( "onPlayerWasted", getRootElement(), onBombGameWasted )
end

function endBombGame()
	if isElement(datBomb) then destroyElement(datBomb) end
	if isElement(datMarkerBomb) then destroyElement(datMarkerBomb) end
	removeEventHandler( "onPlayerWasted", getRootElement(), onBombGameWasted )
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementHealth(player, 100)
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end	
end
function onBombGameWasted ()
	if getPlayerGameMode(source) ~= 4 then return end
	if getElementData(source, "wareWon") == true then
		local randomNumber = math.random(1,3)
		setElementData(source, "wareWon", false)
		callClientFunction(source, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
	end
end