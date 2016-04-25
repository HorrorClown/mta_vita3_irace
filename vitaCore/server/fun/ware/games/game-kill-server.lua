--[[
Project: Vita Ware
File: game-kill-server.lua
Author(s):	Sebihunter
]]--

function startKillGame()
	local wep = math.random(22,31)
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Kill somebody!")
		setElementData(player, "wareWon", false)
		giveWeapon ( player, wep, 500, true )
	end
	addEventHandler( "onPlayerWasted", getRootElement(), onKillGameWasted )
end

function endKillGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		takeAllWeapons ( player )
		setElementHealth(player, 100)
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
	removeEventHandler( "onPlayerWasted", getRootElement(), onKillGameWasted )
end

function onKillGameWasted (ammo, killer)
	if getPlayerGameMode(source) ~= 4 then return end
	if killer ~= false and killer ~= source then
		if getElementData(killer, "wareWon") == false then
			local randomNumber = math.random(1,3)
			setElementData(killer, "wareWon", true)
			callClientFunction(killer, "playSound", "./files/audio/ware/local_exo_won"..tostring(randomNumber)..".wav" )
		end	
	end
end