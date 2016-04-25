--[[
Project: Vita3
File: game-carbreak-client.lua
Author(s):	Sebihunter
]]--

local active = false
local root = getRootElement()

function carbreakairportStart()
	if active then removeEventHandler("onClientRender", root, carbreakairportCheck) end
	addEventHandler("onClientRender", root, carbreakairportCheck)
	active = true
end

function carbreakairportEnd()
	if active == true then
		removeEventHandler("onClientRender", root, carbreakairportCheck)
		active = false
	end
end

function carbreakairportCheck()
	if getPlayerGameMode(getLocalPlayer()) ~= 4 then
		removeEventHandler("onClientRender", root, carbreakairportCheck)
	end
	if getPedOccupiedVehicle(getLocalPlayer()) then
		local x, y, z = getElementVelocity(getPedOccupiedVehicle(getLocalPlayer()))
			if x == 0 and y == 0 and z == 0 then
			local randomnum = math.random(1,3)
			playSound("./files/audio/ware/local_exo_won"..tostring(randomnum)..".wav")
			removeEventHandler("onClientRender", root, carbreakairportCheck)
			active = false
			setElementData(getLocalPlayer(), "wareWon", true)
		end	
	end
end