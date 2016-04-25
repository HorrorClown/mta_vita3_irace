--[[
Project: Vita Ware
File: game-move-server.lua
Author(s):	Sebihunter
]]--


function startMoveGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Move!")
		setElementData(player, "wareWon", true)
	end
	wareTimers[#wareTimers+1] = setTimer(function()
		setTimer(function()
			local randomNumber = math.random(1,3)
			for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
				local vx, vy, vz = getElementVelocity(player)
				if (vx == 0 or vy == 0) and getElementData(player, "wareWon") == true then
					setElementData(player, "wareWon", false)
					callClientFunction(player, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
				end
			end
		end, 100, 15)
		local randomNumber = math.random(1,3)
		for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			local vx, vy, vz = getElementVelocity(player)
			if (vx == 0 or vy == 0) and getElementData(player, "wareWon") == true then
				setElementData(player, "wareWon", false)
				callClientFunction(player, "playSound", "./files/audio/ware/local_lose"..tostring(randomNumber)..".wav" )
			end
		end
	end, 1500, 1)
end

function endMoveGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
end