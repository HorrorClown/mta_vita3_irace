--[[
Project: Vita Ware
File: game-button-server.lua
Author(s):	Sebihunter
]]--
function startButtonGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Click the button!")
		callClientFunction(player, "ButtonStart")
	end		
end

function endButtonGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
		callClientFunction(player, "ButtonEnd")
	end
end