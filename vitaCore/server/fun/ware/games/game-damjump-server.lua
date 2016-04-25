--[[
Project: Vita Ware
File: game-damjump-server.lua
Author(s):	Sebihunter
]]--

function startDamJumpGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementPosition(player, -725.3251953125, 2061.5146484375, 60.3828125)
		setElementData(player, "wareText", "Jump down and get into the water!")
		setElementData(player, "wareWon", false)
	end
	wareTimers[#wareTimers+1] = setTimer(function()
		local randomNumber = math.random(1,3)
		for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			if isElementInWater(player) and getElementData(player, "wareWon") == false then
				setElementData(player, "wareWon", true)
				callClientFunction(player, "playSound", "./files/audio/ware/local_exo_won"..tostring(randomNumber)..".wav" )
			end
		end
	end, 100, 750)	
end

function endDamJumpGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
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
	end
end