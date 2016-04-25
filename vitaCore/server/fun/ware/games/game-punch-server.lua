--[[
Project: Vita Ware
File: game-punch-server.lua
Author(s):	Sebihunter
]]--

function startPunchGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "Punch somebody!")
		setElementData(player, "wareWon", false)
	end
	addEventHandler( "onPlayerDamage", getRootElement(), onPunchGamePunched )
end

function endPunchGame()
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		takeAllWeapons ( player )
		setElementHealth(player, 100)
		if getElementData(player, "wareWon") == true then
			setElementData(player, "wareScore", getElementData(player, "wareScore")+1)
		end
	end
	removeEventHandler( "onPlayerDamage", getRootElement(), onPunchGamePunched )
end

function onPunchGamePunched (attacker)
	if getPlayerGameMode(source) ~= 4 then return end
	if attacker ~= false and attacker ~= source then
		if getElementData(attacker, "wareWon") == false then
			local randomNumber = math.random(1,3)
			setElementData(attacker, "wareWon", true)
			callClientFunction(attacker, "playSound", "./files/audio/ware/local_exo_won"..tostring(randomNumber)..".wav" )
		end	
	end
end