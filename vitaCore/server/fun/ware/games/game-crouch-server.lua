--[[
Project: Vita Ware
File: game-crouch-server.lua
Author(s):	Sebihunter
]]--


function startCrouchGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Crouch!")
	end
end

function endCrouchGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if isPedDucked ( player ) == true then setElementData(player, "wareWon", true) end
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
end
