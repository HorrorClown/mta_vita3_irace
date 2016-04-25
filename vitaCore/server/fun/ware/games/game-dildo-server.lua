--[[
Project: Vita Ware
File: game-dildo-server.lua
Author(s):	Sebihunter
]]--

function startDildoGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Equipt the dildo!")
		setElementData(player, "wareWon", false)
		giveWeapon ( player, 2, 1, false )
		giveWeapon ( player, 10, 1, false ) --DILDO
		giveWeapon ( player, 43, 1, false )	
		giveWeapon ( player, 22, 1, false )	
		giveWeapon ( player, 27, 1, true )	
		giveWeapon ( player, 40, 1, false )	
		toggleControl ( player, "fire", false )
	end
end

function endDildoGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		if getPedWeapon ( player ) == 10 then
			setElementData(player, "wareWon", true)
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
		takeAllWeapons ( player )
		setElementHealth(player, 100)	
		toggleControl ( player, "fire", true )
	end
end