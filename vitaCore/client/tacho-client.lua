--[[
Project: vitaCore
File: selection-client.lua
Author(s):	Jake
			Sebihunter
]]--
 
 
function drawTacho()
	if getPlayerGameMode(getLocalPlayer()) == 0 then return end
	if showUserGui ~= false then return end
	if tachoEnabled == false then return end
	local lp = getLocalPlayer()
	local target = getCameraTarget()
	if target and getElementType(target) == "vehicle" then
		lp = getVehicleOccupant(target)
	end	
	
	if getPedOccupiedVehicle(lp) then
		local healthVeh = getElementHealth ( getPedOccupiedVehicle(lp) ) - 250 --Starts burning @ 250
		local x,y,z = getElementVelocity(getPedOccupiedVehicle(lp))
		local speed = (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		
		if speed > 230 then speed = 230 end
	
	
		if healthVeh > 750 then healthVeh = 750 end
		dxDrawImage(screenWidth-240, screenHeight-218, 256, 256, "files/tacho/tacho.png",0,0,0,tocolor(255,255,255,255))
		local g = (healthVeh/750)*255
		local r = 255-g
		if healthVeh/10 > 0 then
			local sizeHealth = healthVeh/750
			dxDrawImageSection ( screenWidth-35, screenHeight-10-132*sizeHealth, 19, 132*sizeHealth, 0, 132-sizeHealth*132, 19, 132*sizeHealth, "files/tacho/health.png", 0, 0, 0, tocolor(r, g,0,255))
		end
		dxDrawImage(screenWidth-210,screenHeight-166,147,147,"files/tacho/nadel.png",speed+10,0,0,tocolor(255,255,255,255),true) 	
	end
end
addEventHandler("onClientRender",root,drawTacho)