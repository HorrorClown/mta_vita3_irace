--[[
Project: Vita Ware
File: game-land-server.lua
Author(s):	Sebihunter
]]--

local vehicles = {}


function startLandGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Land that plane!")
		local vehicle = createVehicle(513, 1993.69140625, -2492.453125, 200.246124267578)
		setElementRotation(vehicle, 0, 0, 88)
		setElementHealth(vehicle, 1000)
		setElementDimension(vehicle, gGamemodeFUN)
		warpPedIntoVehicle(player, vehicle)
		--setElementVelocity(vehicle, -1.0, 0, 0)
		vehicles[#vehicles+1] = vehicle
	end
	for i, player in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		callClientFunction(player, "blockCarfade", true)
		callClientFunction(player, "wareVehicsCollide", vehicles)
		toggleControl ( player, "enter_exit",false )
	end			
end

function endLandGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if isPedInVehicle ( player ) and isVehicleOnGround ( getPedOccupiedVehicle(player) ) then setElementData(player, "wareWon", true) end
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
		toggleControl ( player, "enter_exit", true )
		
		local x = math.random(-20,20)
		local y = math.random(-20,20)
		spawnPlayer(player, 259.3999023438+x, 359.1000976563+y, 56+2,0,getElementData(player, "Skin"))
		setElementPosition(player, 259.3999023438+x, 359.1000976563+y, 56+2)
		setElementDimension(player, gGamemodeFUN)
		fadeCamera(player, true)
		setCameraTarget(player, player)
		callClientFunction(player, "blockCarfade", false)
	end
	
	for i,v in pairs(vehicles) do
		if isElement(v) then destroyElement(v) end
	end
	
	vehicles = nil 
	vehicles = {}
end