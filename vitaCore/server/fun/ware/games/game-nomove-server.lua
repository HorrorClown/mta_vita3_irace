--[[
Project: Vita Ware
File: game-nomove-server.lua
Author(s):	Sebihunter
]]--


function startNoMoveGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Don't move!")
		setElementData(player, "wareWon", true)
	end
	wareTimers[#wareTimers+1] = setTimer(function()
		setTimer(function()
			local randomNumber = math.random(1,3)
			for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
				local vx, vy, vz = getElementVelocity(player)
				if (vx ~= 0 or vy ~= 0 or vz ~= 0) and getElementData(player, "wareWon") == true then
					setElementData(player, "wareWon", false)
					callClientFunction(player, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
				end
			end
		end, 100, 15)
		local randomNumber = math.random(1,3)
		for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			local vx, vy, vz = getElementVelocity(player)
			if (vx ~= 0 or vy ~= 0 or vz ~= 0) and getElementData(player, "wareWon") == true then
				setElementData(player, "wareWon", false)
				callClientFunction(player, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
			end
		end
	end, 1500, 1)
end

function endNoMoveGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
end