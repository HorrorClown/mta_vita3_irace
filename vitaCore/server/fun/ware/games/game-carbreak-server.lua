--[[
Project: Vita Ware
File: game-carbreak-server.lua
Author(s):	Einstein
]]--

local vehicles = {}


function startCarbreakGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Stop your car!")
		--setElementData( player, "ghostmod", true )
		local vehicle = createVehicle(560, 1993.69140625, -2492.453125, 13.246124267578)
		setElementRotation(vehicle, 0, 0, 88)
		setElementHealth(vehicle, 10000)
		setElementDimension(vehicle, gGamemodeFUN)
		warpPedIntoVehicle(player, vehicle)
		vehicles[#vehicles+1] = vehicle
	end
	
	for i, player in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		callClientFunction(player, "blockCarfade", true)
		callClientFunction(player, "wareVehicsCollide", vehicles)
		callClientFunction(player, "carbreakairportStart")
		toggleControl ( player, "enter_exit", false )
	end		
	
	for i, vehicle in pairs(vehicles) do
		setElementVelocity(vehicle, -5.0, 0, 0)
	end	
end

function endCarbreakGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData( player, "ghostmod", false )
		toggleControl ( player, "enter_exit", true )
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
		
		local x = math.random(-20,20)
		local y = math.random(-20,20)
		spawnPlayer(player, 259.3999023438+x, 359.1000976563+y, 56+2,0,getElementData(player, "Skin"))
		setElementPosition(player, 259.3999023438+x, 359.1000976563+y, 56+2)
		setElementDimension(player, gGamemodeFUN)
		fadeCamera(player, true)
		setCameraTarget(player, player)
		callClientFunction(player, "carbreakairportEnd")
		callClientFunction(player, "blockCarfade", false)
	end
	
	for i,v in pairs(vehicles) do
		if isElement(v) then destroyElement(v) end
	end
	
	vehicles = nil 
	vehicles = {}
end